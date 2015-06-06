import nbtd;

import std.bitmanip;
import std.conv;

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

	// No Float/Double Encoding encode tests due to precision

	NBTByteArray nbtBytes = new NBTByteArray(cast(byte[])[0, 12, 42, 5]);
	assert(nbtBytes.encode(false) == cast(ubyte[])[7, 0, 0] ~ cast(ubyte[])nativeToBigEndian(cast(int)nbtBytes.value.length) ~ cast(ubyte[])nbtBytes.value);

	NBTString nbtText = new NBTString("Hello World");
	assert(nbtText.encode(false) == cast(ubyte[])[8, 0, 0] ~ cast(ubyte[])nativeToBigEndian(cast(short)nbtText.value.length) ~ cast(ubyte[])nbtText.value);

	NBTIntArray nbtInts = new NBTIntArray([5, 555]);
	assert(nbtInts.encode(false) == cast(ubyte[])[11, 0, 0] ~ cast(ubyte[])nativeToBigEndian(cast(int)nbtInts.value.length) ~ cast(ubyte[])nativeToBigEndian(5) ~ cast(ubyte[])nativeToBigEndian(555));

	NBTList nbtShorts = new NBTList([nbtShort]);
	assert(nbtShorts.encode(false) == cast(ubyte[])[9, 0, 0, 2] ~ cast(ubyte[])nativeToBigEndian(cast(int)1) ~ cast(ubyte[])nativeToBigEndian(cast(short)5));
}
