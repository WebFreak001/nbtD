module nbtd;

public
{
	import nbtd.INBTItem;
	import nbtd.NBTCommon;
	import nbtd.NBTEnd;
	import nbtd.NBTList;
	import nbtd.NBTCompound;

	/// Helper function for uncompressing a full GZip byte array
	ubyte[] uncompressGZip(ubyte[] data)
	{
		import std.zlib;

		UnCompress uncompressor = new UnCompress(HeaderFormat.gzip);
		ubyte[] result;
		while(data.length > 1024)
		{
			result ~= cast(ubyte[])uncompressor.uncompress(data[0 .. 1024]);
			data = data[1024 .. $];
		}
		result ~= cast(ubyte[])uncompressor.uncompress(data);
		result ~= cast(ubyte[])uncompressor.flush();
		return result;
	}

	/// Helper function for GZiping a full byte array
	ubyte[] compressGZip(ubyte[] data)
	{
		import std.zlib;

		Compress compressor = new Compress(HeaderFormat.gzip);
		ubyte[] result;
		while(data.length > 1024)
		{
			result ~= cast(ubyte[])compressor.compress(data[0 .. 1024]);
			data = data[1024 .. $];
		}
		result ~= cast(ubyte[])compressor.compress(data);
		result ~= cast(ubyte[])compressor.flush();
		return result;
	}

	/// Function to read a element from a stream and advance the stream
	INBTItem parseElement(ref ubyte[] stream, bool hasName = true)
	{
		import std.conv;

		switch(stream[0])
		{
		case 0:
			if(hasName)
				stream = stream[1 .. $];
			return new NBTEnd();
		case 1:
		{
			auto value = new NBTByte();
			value.read(stream, hasName);
			return value;
		}
		case 2:
		{
			auto value = new NBTShort();
			value.read(stream, hasName);
			return value;
		}
		case 3:
		{
			auto value = new NBTInt();
			value.read(stream, hasName);
			return value;
		}
		case 4:
		{
			auto value = new NBTLong();
			value.read(stream, hasName);
			return value;
		}
		case 5:
		{
			auto value = new NBTFloat();
			value.read(stream, hasName);
			return value;
		}
		case 6:
		{
			auto value = new NBTDouble();
			value.read(stream, hasName);
			return value;
		}
		case 7:
		{
			auto value = new NBTByteArray();
			value.read(stream, hasName);
			return value;
		}
		case 8:
		{
			auto value = new NBTString();
			value.read(stream, hasName);
			return value;
		}
		case 9:
		{
			auto value = new NBTList();
			value.read(stream, hasName);
			return value;
		}
		case 10:
		{
			auto value = new NBTCompound();
			value.read(stream, hasName);
			return value;
		}
		case 11:
		{
			auto value = new NBTIntArray();
			value.read(stream, hasName);
			return value;
		}
		default:
			throw new Exception("Invalid NBT-TAG(" ~ to!string(stream[0]) ~ ")!");
		}
	}

	/// Function to read a specified element from a stream and advance the stream
	INBTItem parseElement(NBTType type, ref ubyte[] stream, bool hasName = true)
	{
		import std.conv;

		switch(type)
		{
		case 0:
			if(hasName)
				stream = stream[1 .. $];
			return new NBTEnd();
		case 1:
		{
			auto value = new NBTByte();
			value.read(stream, hasName);
			return value;
		}
		case 2:
		{
			auto value = new NBTShort();
			value.read(stream, hasName);
			return value;
		}
		case 3:
		{
			auto value = new NBTInt();
			value.read(stream, hasName);
			return value;
		}
		case 4:
		{
			auto value = new NBTLong();
			value.read(stream, hasName);
			return value;
		}
		case 5:
		{
			auto value = new NBTFloat();
			value.read(stream, hasName);
			return value;
		}
		case 6:
		{
			auto value = new NBTDouble();
			value.read(stream, hasName);
			return value;
		}
		case 7:
		{
			auto value = new NBTByteArray();
			value.read(stream, hasName);
			return value;
		}
		case 8:
		{
			auto value = new NBTString();
			value.read(stream, hasName);
			return value;
		}
		case 9:
		{
			auto value = new NBTList();
			value.read(stream, hasName);
			return value;
		}
		case 10:
		{
			auto value = new NBTCompound();
			value.read(stream, hasName);
			return value;
		}
		case 11:
		{
			auto value = new NBTIntArray();
			value.read(stream, hasName);
			return value;
		}
		default:
			throw new Exception("Invalid NBT-TAG(" ~ to!string(type) ~ ")!");
		}
	}
}
