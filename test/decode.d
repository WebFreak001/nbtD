import nbtd;

import std.bitmanip;

unittest
{
	NBTByte nbtByte = new NBTByte();
	nbtByte.decode(cast(ubyte[])[1, 0, 0, 5], false);
	assert(nbtByte.name == "");
	assert(nbtByte.value == 5);

	NBTShort nbtShort = new NBTShort();
	nbtShort.decode(cast(ubyte[])[2, 0, 0] ~ cast(ubyte[])nativeToBigEndian(cast(short)5), false);
	assert(nbtShort.name == "");
	assert(nbtShort.value == 5);

	NBTInt nbtInt = new NBTInt();
	nbtInt.decode(cast(ubyte[])[3, 0, 0] ~ cast(ubyte[])nativeToBigEndian(cast(int)5), false);
	assert(nbtInt.name == "");
	assert(nbtInt.value == 5);

	NBTLong nbtLong = new NBTLong();
	nbtLong.decode(cast(ubyte[])[4, 0, 0] ~ cast(ubyte[])nativeToBigEndian(cast(long)5), false);
	assert(nbtLong.name == "");
	assert(nbtLong.value == 5);

	NBTString nbtText = new NBTString();
	nbtText.decode(cast(ubyte[])[8, 0, 0] ~ cast(ubyte[])nativeToBigEndian(cast(short)11) ~ cast(ubyte[])"Hello World", false);
	assert(nbtText.name == "");
	assert(nbtText.value == "Hello World");
}
