module nbtd.NBTEnd;

import nbtd;
import std.zlib;

/// Class for indicating the End of a compound
class NBTEnd : INBTItem
{
private:
	string _name;
public:
	this()
	{
	}

	@property NBTType type() { return NBTType.End; }
	/// Will return 0
	@property size_t size() { return 0; }

	/// Name cannot be get
	@property string name() { throw new Exception("NBTEnd has no name!"); }
	/// Name cannot be set
	@property void name(string name) { throw new Exception("NBTEnd can not have a name!"); }

	/// Value cannot be get
	@property byte value() { throw new Exception("NBTEnd has no value!"); }
	/// Value cannot be set
	@property void value(byte value) { throw new Exception("NBTEnd can not have a value!"); }

	/// Will return [0] if hasName is true and [] if hasName is false.
	ubyte[] encode(bool compressed = true, bool hasName = true)
	{
		ubyte[] data;
		if(hasName)
			data = [cast(ubyte)0];
		else
			data = [];
		if(compressed)
		{
			return compressGZip(data);
		}
		return data;
	}

	/// Will only check if first byte is 0 if hasName is true
	void decode(ubyte[] data, bool compressed = true, bool hasName = true)
	{
		if(compressed)
		{
			data = uncompressGZip(data);
		}

		if(hasName)
			assert(data[0] == cast(ubyte)type);
	}

	/// Will only advance the stream 1 character if hasName is true
	void read(ref ubyte[] stream, bool hasName = true)
	{
		if(hasName)
			stream = stream[1 .. $];
	}

	@property INBTItem dup()
	{
		return new NBTEnd();
	}

	/// Returns: `"NBTEnd"`
	override string toString()
	{
		return "NBTEnd";
	}
}
