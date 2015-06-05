module nbtd.NBTString;

import nbtd;

import std.bitmanip;
import std.zlib;

class NBTString : INBTItem
{
private:
	string _name;
	string _value;
public:
	this(string value = "")
	{
		_name = "";
		_value = value;
	}

	@property NBTType type() { return NBTType.String; }
	@property int size() { return _value.length + 2; }

	@property string name() { return _name; }
	@property void name(string name) { assert(name.length < short.sizeof); _name = name; }

	@property string value() { return _value; }
	@property void value(string value) { _value = value; }

	ubyte[] encode(bool compressed = true)
	{
		ubyte[] data = new ubyte[3 + name.length + size];
		data[0] = cast(ubyte)type;
		data.write!short(cast(short)name.length, 1);
		data[3 .. 3 + name.length] = cast(ubyte[])name;
		data.write!short(cast(short)value.length, 3 + name.length);
		data[5 + name.length .. 5 + name.length + value.length] = cast(ubyte[])value;

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
		short valueLength = data.peek!short(3 + nameLength);
		_value = cast(string)data[5 + nameLength .. 5 + nameLength + valueLength];
	}
}
