module nbtd.NBTCommon;

import nbtd;

import std.bitmanip;
import std.zlib;

mixin template NBTCommon(NBTType id, T)
{
private:
	string _name;
	T _value;
public:
	this(T value = cast(T)0)
	{
		_name = "";
		_value = value;
	}

	@property NBTType type() { return id; }
	@property int size() { return T.sizeof; }

	@property string name() { return _name; }
	@property void name(string name) { assert(name.length < short.sizeof); _name = name; }

	@property T value() { return _value; }
	@property void value(T value) { _value = value; }

	ubyte[] encode(bool compressed = true)
	{
		ubyte[] data = new ubyte[3 + name.length + size];
		data[0] = cast(ubyte)type;
		data.write!short(cast(short)name.length, 1);
		data[3 .. 3 + name.length] = cast(ubyte[])name;
		data.write!T(_value, 3 + name.length);

		if(compressed)
		{
			Compress compressor = new Compress(HeaderFormat.gzip);
			return cast(ubyte[])compressor.compress(data);
		}
		return data;
	}

	void decode(ubyte[] data, bool compressed = true)
	{
		if(compressed)
		{
			UnCompress uncompressor = new UnCompress(HeaderFormat.gzip);
			data = cast(ubyte[])uncompressor.uncompress(data);
		}

		assert(data[0] == cast(ubyte)type);
		short nameLength = data.peek!short(1);
		_name = cast(string)data[3 .. 3 + nameLength];
		_value = data.peek!T(3 + nameLength);
	}
}

class NBTByte : INBTItem
{
	mixin NBTCommon!(NBTType.Byte, byte);
}

class NBTShort : INBTItem
{
	mixin NBTCommon!(NBTType.Short, short);
}

class NBTInt : INBTItem
{
	mixin NBTCommon!(NBTType.Int, int);
}

class NBTLong : INBTItem
{
	mixin NBTCommon!(NBTType.Long, long);
}

class NBTFloat : INBTItem
{
	mixin NBTCommon!(NBTType.Float, float);
}

class NBTDouble : INBTItem
{
	mixin NBTCommon!(NBTType.Double, double);
}
