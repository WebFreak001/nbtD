module nbtd.NBTEnd;

import nbtd;
import std.zlib;

class NBTEnd : INBTItem
{
private:
	string _name;
public:
	this()
	{
	}

	@property NBTType type() { return NBTType.End; }
	@property int size() { return 0; }

	@property string name() { throw new Exception("NBTEnd has no name!"); }
	@property void name(string name) { throw new Exception("NBTEnd can not have a name!"); }

	@property byte value() { throw new Exception("NBTEnd has no value!"); }
	@property void value(byte value) { throw new Exception("NBTEnd can not have a value!"); }

	ubyte[] encode(bool compressed = true, bool hasName = true)
	{
		ubyte[] data;
		if(hasName)
			data = [cast(ubyte)0];
		else
			data = [];
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
			UnCompress uncompressor = new UnCompress(HeaderFormat.gzip);
			data = cast(ubyte[])uncompressor.uncompress(data);
		}

		if(hasName)
			assert(data[0] == cast(ubyte)type);
	}

	void read(ref ubyte[] stream, bool hasName = true)
	{
		if(hasName)
			stream = stream[1 .. $];
	}
}
