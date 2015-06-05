module nbtd.NBTLong;

import nbtd;

import std.bitmanip;
import std.zlib;

class NBTLong : INBTItem
{
private:
	string _name;
	long _value;
public:
	this(long value = cast(long)0)
	{
		_name = "";
		_value = value;
	}

	@property NBTType type() { return NBTType.Long; }
	@property int size() { return 8; }

	@property string name() { return _name; }
	@property void name(string name) { assert(name.length < short.sizeof); _name = name; }

	@property long value() { return _value; }
	@property void value(long value) { _value = value; }

	ubyte[] encode(bool compressed = true)
	{
		ubyte[] data = new ubyte[3 + name.length + size];
		data[0] = cast(ubyte)type;
		data.write!short(cast(short)name.length, 1);
		data[3 .. 3 + name.length] = cast(ubyte[])name;
		data.write!long(_value, 3 + name.length);

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
		_value = data.peek!long(3 + nameLength);
	}
}
