module nbtd;

public
{
	import nbtd.INBTItem;
	import nbtd.NBTCommon;
	import nbtd.NBTEnd;
	import nbtd.NBTList;

	INBTItem parseElement(ref ubyte[] stream, bool hasName = true)
	{
		import std.conv;

		switch(stream[0])
		{
		case 0:
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
			throw new Exception("Compound is unsupported!");
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

	INBTItem parseElement(NBTType type, ref ubyte[] stream, bool hasName = true)
	{
		import std.conv;

		switch(type)
		{
		case 0:
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
			throw new Exception("Compound is unsupported!");
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
