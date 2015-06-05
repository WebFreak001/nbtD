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
	@property int size() { return 1; }

	@property string name() { throw new Exception("NBTEnd has no name!"); }
	@property void name(string name) { throw new Exception("NBTEnd can not have a name!"); }

	@property byte value() { throw new Exception("NBTEnd has no value!"); }
	@property void value(byte value) { throw new Exception("NBTEnd can not have a value!"); }

	ubyte[] encode(bool compressed = true)
	{
		ubyte[] data = [cast(ubyte)0];
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
	}
}
