module nbtd.NBTCommon;

import nbtd;

import std.bitmanip;
import std.zlib;
import std.traits;
import std.format;

mixin template NBTCommon(NBTType id, T, PrefixLength = int)
{
private:
	string _name;
	T _value;
public:
	this()
	{
		_name = "";
	}

	this(T value)
	{
		_name = "";
		_value = value;
	}

	@property NBTType type() { return id; }
	@property int size() { static if(isArray!T) { return typeof(_value[0]).sizeof * _value.length + PrefixLength.sizeof; } else { return T.sizeof; } }

	@property string name() { return _name; }
	@property void name(string name) { assert(name.length < short.sizeof); _name = name; }

	@property T value() { return _value; }
	@property void value(T value) { _value = value; }

	ubyte[] encode(bool compressed = true, bool writeName = true)
	{
		ubyte[] data;
		if(writeName) data = new ubyte[3 + name.length + size];
		else data = new ubyte[size];

		if(writeName)
		{
			data[0] = cast(ubyte)type;

			data.write!short(cast(short)name.length, 1);
			data[3 .. 3 + name.length] = cast(ubyte[])name;
			static if(isArray!T)
			{
				data.write!PrefixLength(cast(PrefixLength)value.length, 3 + name.length);
				for(int i = 0; i < value.length; i++)
					data.write!(typeof(_value[0]))(_value[i], 3 + PrefixLength.sizeof + name.length + i * typeof(_value[0]).sizeof);
			}
			else
			{
				data.write!T(_value, 3 + name.length);
			}
		}
		else
		{
			static if(isArray!T)
			{
				data.write!PrefixLength(cast(PrefixLength)value.length, 0);
				for(int i = 0; i < value.length; i++)
					data.write!(typeof(_value[0]))(_value[i], PrefixLength.sizeof + i * typeof(_value[0]).sizeof);
			}
			else
			{
				data.write!T(_value, 0);
			}
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
			assert(stream.read!ubyte == cast(ubyte)this.type);
			short nameLength = stream.read!short;
			_name = cast(string)stream[0 .. nameLength];
			stream = stream[nameLength .. $];
		}

		static if(isArray!T)
		{
			alias ElemType = typeof(_value[0]);
			PrefixLength arrLength = stream.read!PrefixLength;
			T arr;
			for(int i = 0; i < arrLength; i++)
				arr ~= stream.read!ElemType;
			_value = arr;
		}
		else
		{
			_value = stream.read!T;
		}
	}

	override string toString()
	{
		return format("%s('%s') = %s", type, name, value);
	}

	static if(isArray!T)
	{
		typeof(_value[0]) opIndex(size_t index)
		{
			return _value[index];
		}

		T opIndex()
		{
			return _value[];
		}

		T opSlice(size_t start, size_t end)
		{
			return _value[start .. end];
		}

		size_t opDollar()
		{
			return _value.length;
		}

		@property size_t length()
		{
			return _value.length;
		}
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

class NBTByteArray : INBTItem
{
	mixin NBTCommon!(NBTType.ByteArray, byte[]);
}

class NBTString : INBTItem
{
	mixin NBTCommon!(NBTType.String, string, short);
}

class NBTIntArray : INBTItem
{
	mixin NBTCommon!(NBTType.IntArray, int[]);
}
