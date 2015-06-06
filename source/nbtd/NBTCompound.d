module nbtd.NBTCompound;

import nbtd;

import std.zlib;
import std.bitmanip;
import std.format;

class NBTCompound : INBTItem
{
private:
	string _name;
	INBTItem[] _value;
public:
	this()
	{
		_name = "";
	}

	this(INBTItem[] items)
	{
		_name = "";
		_value = items;
	}

	@property NBTType type() { return NBTType.Compound; }
	@property int size()
	{
		int size = 1; // incl. EndTag
		foreach(INBTItem item; _value)
			size += item.size;
		return size;
	}

	@property string name() { return _name; }
	@property void name(string name) { _name = name; }

	@property INBTItem[] value() { return _value; }
	@property void value(INBTItem[] value) { _value = value; }

	T get(T : INBTItem = INBTItem)(string name)
	{
		foreach(INBTItem item; _value)
			if(item.name == name)
				return cast(T)item;
		return null;
	}

	ubyte[] encode(bool compressed = true, bool hasName = true)
	{
		ubyte[] data;
		if(hasName)
			data = new ubyte[size + 3 + _name.length];
		else
			data = new ubyte[size];

		if(hasName)
		{
			data[0] = cast(ubyte)type;
			data.write(cast(short)_name.length, 1);
			data[3 .. 3 + _name.length] = cast(ubyte[])_name;
			int index = 3 + name.length;
			for(int i = 0; i < _value.length; i++)
			{
				ubyte[] buffer = _value[i].encode(false);
				data[index .. index + buffer.length] = buffer;
				index += buffer.length;
			}
			data[index] = cast(ubyte)0;
			assert(index == data.length - 1);
		}
		else
		{
			int index = 0;
			for(int i = 0; i < _value.length; i++)
			{
				ubyte[] buffer = _value[i].encode(false);
				data[index .. index + buffer.length] = buffer;
				index += buffer.length;
			}
			data[index] = cast(ubyte)0;
			assert(index == data.length - 1);
		}

		if(compressed)
		{
			Compress compressor = new Compress(HeaderFormat.gzip);
			return cast(ubyte[])compressor.compress(data);
		}
		return data;
	}

	void decode(ubyte[] data, bool compressed = true, bool hasName = true)
	{
		if(compressed)
		{
			data = uncompressGZip(data);
		}

		read(data, hasName);
	}

	void read(ref ubyte[] stream, bool hasName = true)
	{
		_name = "";
		if(hasName)
		{
			assert(stream.read!ubyte == cast(ubyte)type);
			short nameLength = stream.read!short;
			_name = cast(string)stream[0 .. nameLength];
			stream = stream[nameLength .. $];
		}
		INBTItem item;
		_value.length = 0;
		while((item = parseElement(stream)).type != NBTType.End)
			_value ~= item;
	}

	override string toString()
	{
		return format("NBTCompound('%s') = {%s}", name, value);
	}

	INBTItem opIndex(string index)
	{
		return get(index);
	}
}
