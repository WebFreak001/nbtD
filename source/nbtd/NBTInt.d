module nbtd.NBTInt;

import nbtd;

import std.bitmanip;
import std.zlib;

class NBTInt : INBTItem
{
private:
	string _name;
	int _value;
public:
	this(int value = 0)
	{
		_name = "";
		_value = value;
	}

	@property NBTType type() { return NBTType.Int; }
	@property int size() { return 4; }

	@property string name() { return _name; }
	@property void name(string name) { assert(name.length < short.sizeof); _name = name; }

	@property int value() { return _value; }
	@property void value(int value) { _value = value; }

	ubyte[] encode(bool compressed = true)
	{
		ubyte[] data = new ubyte[3 + name.length + size];
		data[0] = cast(ubyte)type;
		data.write!short(cast(short)name.length, 1);
		data[3 .. 3 + name.length] = cast(ubyte[])name;
		data.write!int(_value, 3 + name.length);

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
		_value = data.peek!int(3 + nameLength);
	}
}
