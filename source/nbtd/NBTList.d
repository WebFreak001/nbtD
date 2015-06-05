module nbtd.NBTList;

import std.bitmanip;
import std.zlib;

import nbtd;

class NBTList : INBTItem
{
private:
	string _name;
	NBTType _elementType;
	INBTItem[] _items;
public:
	this()
	{
		_name = "";
		_items = [];
	}

	this(INBTItem[] items)
	{
		_name = "";
		if(items.length > 0)
		{
			_elementType = items[0].type;
			value = items;
		}
	}

	@property NBTType type() { return NBTType.List; }
	@property int size() { int len = 0; for(int i = 0; i < _items.length; i++) len += _items[i].size; return 5 + len; }

	@property string name() { return _name; }
	@property void name(string name) { _name = name; }

	@property INBTItem[] value() { return _items; }
	@property void value(INBTItem[] value)
	{
		for(int i = 0; i < value.length; i++)
			assert(value[i].type == elementType);
		_items = value;
	}

	@property ref elementType() { return _elementType; }

	ubyte[] encode(bool compressed = true, bool hasName = true)
	{
		ubyte[] data;
		if(hasName) data = new ubyte[3 + name.length + size];
		else data = new ubyte[size];

		int dataIndex = 0;

		if(hasName)
		{
			data[0] = cast(ubyte)type;

			data.write!short(cast(short)name.length, 1);
			data[3 .. 3 + name.length] = cast(ubyte[])name;

			data[3 + name.length] = cast(ubyte)elementType;
			data.write!int(cast(int)value.length, 4 + name.length);
			dataIndex = 8 + name.length;
		}
		else
		{
			data[0] = cast(ubyte)elementType;
			data.write!int(cast(int)value.length, 1);
			dataIndex = 5;
		}

		for(int i = 0; i < value.length; i++)
		{
			auto buffer = value[i].encode(false, false);
			data[dataIndex .. dataIndex + buffer.length] = buffer;
			dataIndex += buffer.length;
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
		ubyte[] stream = data.dup;
		assert(stream.read!ubyte == type);
		if(hasName)
		{

		}
	}

	void read(ref ubyte[] stream, bool hasName = true)
	{
	}
}
