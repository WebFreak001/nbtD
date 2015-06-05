module nbtd.NBTShort;

import nbtd;

import std.bitmanip;
import std.zlib;

class NBTShort : INBTItem
{
private:
	string _name;
	short _value;
public:
	this(short value = cast(short)0)
	{
		_name = "";
		_value = value;
	}

	@property NBTType type() { return NBTType.Short; }
	@property int size() { return 2; }

	@property string name() { return _name; }
	@property void name(string name) { assert(name.length < short.sizeof); _name = name; }

	@property short value() { return _value; }
	@property void value(short value) { _value = value; }

	ubyte[] encode(bool compressed = true)
	{
		ubyte[] data = new ubyte[3 + name.length + size];
		data[0] = cast(ubyte)type;
		data.write!short(cast(short)name.length, 1);
		data[3 .. 3 + name.length] = cast(ubyte[])name;
		data.write!short(_value, 3 + name.length);

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
		_value = data.peek!short(3 + nameLength);
	}
}
