import nbtd;

import std.bitmanip;

unittest
{
	NBTByte nbtByte = new NBTByte(cast(byte)5);
	assert(nbtByte.encode(false) == cast(ubyte[])[1, 0, 0, 5]);

	NBTShort nbtShort = new NBTShort(cast(short)5);
	assert(nbtShort.encode(false) == cast(ubyte[])[2, 0, 0] ~ cast(ubyte[])nativeToBigEndian(cast(short)5));

	NBTInt nbtInt = new NBTInt(cast(int)5);
	assert(nbtInt.encode(false) == cast(ubyte[])[3, 0, 0] ~ cast(ubyte[])nativeToBigEndian(cast(int)5));

	NBTLong nbtLong = new NBTLong(cast(long)5);
	assert(nbtLong.encode(false) == cast(ubyte[])[4, 0, 0] ~ cast(ubyte[])nativeToBigEndian(cast(long)5));

	NBTString nbtText = new NBTString("Hello World");
	assert(nbtText.encode(false) == [cast(ubyte)8] ~ cast(ubyte[])nativeToBigEndian(11) ~ cast(ubyte[])nbtText.value);
}
