module nbtd.NBTCompound;

import nbtd;

import std.zlib;
import std.bitmanip;
import std.format;

/// NBT Compound containing a array of named items.
class NBTCompound : INBTItem
{
private:
	string _name;
	INBTItem[] _value;
public:
	this(INBTItem[] items = [], string name = "")
	{
		_name = name;
		_value = items;
	}

	@property NBTType type() { return NBTType.Compound; }
	@property size_t size()
	{
		size_t size = 1; // incl. EndTag
		foreach(INBTItem item; _value)
			size += item.size + 3 + item.name.length;
		return size;
	}

	@property string name() { return _name; }
	@property void name(string name) { assert(name.length < short.max, "Name is too long! (%s)".format(name.length)); _name = name; }

	@property INBTItem[] value() { return _value; }
	@property void value(INBTItem[] value) { _value = value; }

	/// Returns: the item with the name `name`.
	/// Params:
	/// 	name =			Name to search for.
	/// 	throwOnError =	When false, returns null instead of throwing an exception.
	/// Throws: Exception when unable to cast to the target type.
	/// Throws: Exception when unable to find `name` in the array.
	T get(T : INBTItem = INBTItem)(string name, bool throwOnError = true)
	{
		foreach(INBTItem item; _value)
			if(item.name == name)
			{
				if(cast(T)item)
					return cast(T)item;
				if(throwOnError)
					throw new Exception("Can't cast item to " ~ T.stringof);
				return null;
			}
		if(throwOnError)
			throw new Exception("Item " ~ name ~ " not found in Compound!");
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
			size_t index = 3 + name.length;
			for(size_t i = 0; i < _value.length; i++)
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
			size_t index = 0;
			for(size_t i = 0; i < _value.length; i++)
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

	@property INBTItem dup()
	{
		auto copy = new NBTCompound();
		copy.name = name;
		copy.value = value;
		return copy;
	}

	/// Returns: `"NBTCompound('name') = {[each ChildElement.toString()]}"`
	override string toString()
	{
		return format("NBTCompound('%s') = {%s}", name, value);
	}

	/// See_Also: get
	INBTItem opIndex(string index)
	{
		return get(index);
	}

	/// Sets the value at `index` to a duplicate of item and will rename the item name to `index`.
	INBTItem opIndexAssign(INBTItem item, string index)
	{
		ptrdiff_t found = -1;
		item = item.dup;
		item.name = index;
		foreach(ptrdiff_t i, INBTItem val; _value)
			if(val.name == index)
				found = i;
		if(found == -1)
		{
			_value ~= item;
		}
		else
		{
			_value[found] = item;
		}
		return item;
	}
}
