import nbtd;

import std.bitmanip;
import std.conv;

unittest
{
	NBTByte nbtByte = new NBTByte(cast(byte)5);
	assert(nbtByte.encode(false, false) == cast(ubyte[])[5]);

	NBTShort nbtShort = new NBTShort(cast(short)5);
	assert(nbtShort.encode(false, false) == cast(ubyte[])nativeToBigEndian(cast(short)5));

	NBTInt nbtInt = new NBTInt(cast(int)5);
	assert(nbtInt.encode(false, false) == cast(ubyte[])nativeToBigEndian(cast(int)5));

	NBTLong nbtLong = new NBTLong(cast(long)5);
	assert(nbtLong.encode(false, false) == cast(ubyte[])nativeToBigEndian(cast(long)5));

	// No Float/Double Encoding encode tests due to precision

	NBTByteArray nbtBytes = new NBTByteArray(cast(byte[])[0, 12, 42, 5]);
	assert(nbtBytes.encode(false, false) == cast(ubyte[])nativeToBigEndian(cast(int)nbtBytes.value.length) ~ cast(ubyte[])nbtBytes.value);

	NBTString nbtText = new NBTString("Hello World");
	assert(nbtText.encode(false, false) == cast(ubyte[])nativeToBigEndian(cast(short)nbtText.value.length) ~ cast(ubyte[])nbtText.value);

	NBTList nbtShorts = new NBTList([nbtShort]);
	assert(nbtShorts.encode(false, false) == cast(ubyte[])[2] ~ cast(ubyte[])nativeToBigEndian(cast(int)1) ~ cast(ubyte[])nativeToBigEndian(cast(short)5));

	NBTCompound nbtCompound = new NBTCompound();
	assert(nbtCompound.encode(false, false) == cast(ubyte[])[0]);

	NBTIntArray nbtInts = new NBTIntArray([5, 555]);
	assert(nbtInts.encode(false, false) == cast(ubyte[])nativeToBigEndian(cast(int)nbtInts.value.length) ~ cast(ubyte[])nativeToBigEndian(5) ~ cast(ubyte[])nativeToBigEndian(555));
}
