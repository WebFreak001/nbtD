module nbtd;

public
{
	import nbtd.INBTItem;
	import nbtd.NBTByte;
	import nbtd.NBTShort;
	import nbtd.NBTInt;
	import nbtd.NBTLong;
	import nbtd.NBTEnd;
	import nbtd.NBTString;

	INBTItem parseNBT(ubyte[] data, bool compressed = true)
	{
		import std.conv;
		import std.zlib;

		if(compressed)
		{
			UnCompress uncompressor = new UnCompress(HeaderFormat.gzip);
			data = cast(ubyte[])uncompressor.uncompress(data);
		}

		switch(data[0])
		{
		case 0:
			return new NBTEnd();
		case 1:
		{
			auto value = new NBTByte();
			value.decode(data, false);
			return value;
		}
		case 2:
		{
			auto value = new NBTShort();
			value.decode(data, false);
			return value;
		}
		case 3:
		{
			auto value = new NBTInt();
			value.decode(data, false);
			return value;
		}
		case 4:
		{
			auto value = new NBTLong();
			value.decode(data, false);
			return value;
		}
		case 5:
			throw new Exception("Float is unsupported!");
		case 6:
			throw new Exception("Double is unsupported!");
		case 7:
			throw new Exception("ByteArray is unsupported!");
		case 8:
		{
			auto value = new NBTString();
			value.decode(data, false);
			return value;
		}
		case 9:
			throw new Exception("List is unsupported!");
		case 10:
			throw new Exception("Compound is unsupported!");
		case 11:
			throw new Exception("IntArray is unsupported!");
		default:
			throw new Exception("Invalid NBT-TAG(" ~ to!string(data[0]) ~ ")!");
		}
	}
}
