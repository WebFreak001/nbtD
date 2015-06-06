module nbtd.NBTList;

import std.bitmanip;
import std.zlib;
import std.format;

import nbtd;

class NBTList : INBTItem
{
private:
	string _name;
	NBTType _elementType;
	INBTItem[] _items;
public:
	this(INBTItem[] items = [], string name = "")
	{
		_name = name;
		if(items.length > 0)
		{
			_elementType = items[0].type;
			value = items;
		}
	}

	@property NBTType type() { return NBTType.List; }
	@property int size() { int len = 0; for(int i = 0; i < _items.length; i++) len += _items[i].size; return 5 + len; }

	@property string name() { return _name; }
	@property void name(string name) { assert(name.length < short.max, "Name is too long! (%s)".format(name.length)); _name = name; }

	@property INBTItem[] value() { return _items; }
	@property void value(INBTItem[] value)
	{
		for(int i = 0; i < value.length; i++)
			assert(value[i].type == elementType);
		_items = value[];
	}

	@property ref elementType() { return _elementType; }

	T get(T : INBTItem = INBTItem)(size_t index)
	{
		return cast(T)_items[index];
	}

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
			return compressGZip(data);
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
			assert(stream.read!ubyte == type);
			short nameLength = stream.read!short;
			_name = cast(string)stream[0 .. nameLength];
			stream = stream[nameLength .. $];
		}
		elementType = cast(NBTType)stream.read!ubyte;
		int arrLength = stream.read!int;
		_items.length = 0;
		for(int i = 0; i < arrLength; i++)
			_items ~= parseElement(elementType, stream, false);
	}

	@property INBTItem dup()
	{
		auto copy = new NBTList();
		copy.name = name;
		copy.value = value;
		return copy;
	}

	override string toString()
	{
		return toString(100);
	}

	string toString(int lineLength)
	{
		string items = format("%s", value);
		if(items.length > lineLength - 21)
			return format("NBTList('%s') = %s...", name, items[0 .. lineLength - 21]);
		return format("NBTList('%s') = %s", name, items);
	}

	NBTList opBinary(string op)(INBTItem item)
	{
		static if(op == "~")
		{
			NBTList copy = new NBTList();
			copy.name = name;
			copy.value = value ~ item;
			return copy;
		}
		else static assert(0, "Operator " ~ op ~ " is not implemented!");
	}

	NBTList opOpAssign(string op)(INBTItem item)
	{
		static if(op == "~")
		{
			if(_value.length == 0)
				elementType = item.type;
			assert(item.type == elementType);
			_value ~= item;
			return this;
		}
		else static assert(0, "Operator " ~ op ~ " is not implemented!");
	}

	NBTList opOpAssign(string op)(INBTItem[] items)
	{
		static if(op == "~")
		{
			if(items.length == 0)
				return this;
			if(_value.length == 0)
				elementType = items[0].type;
			foreach(item; items)
				assert(item.type == elementType);
			_value ~= items;
			return this;
		}
		else static assert(0, "Operator " ~ op ~ " is not implemented!");
	}

	INBTItem opIndex(size_t index)
	{
		return _items[index];
	}

	INBTItem[] opIndex()
	{
		return _items[];
	}

	INBTItem[] opSlice(size_t start, size_t end)
	{
		return _items[start .. end];
	}

	size_t opDollar()
	{
		return _items.length;
	}

	@property size_t length()
	{
		return _items.length;
	}
}
