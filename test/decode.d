import nbtd;

import std.bitmanip;
import std.math;
import std.conv;

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

	NBTFloat nbtFloat = new NBTFloat();
	nbtFloat.decode(cast(ubyte[])[5, 0, 0] ~ cast(ubyte[])nativeToBigEndian(cast(float)5.5f), false);
	assert(nbtFloat.name == "");
	assert(abs(nbtFloat.value - 5.5f) < 0.01f);

	NBTDouble nbtDouble = new NBTDouble();
	nbtDouble.decode(cast(ubyte[])[6, 0, 0] ~ cast(ubyte[])nativeToBigEndian(cast(double)5.5), false);
	assert(nbtDouble.name == "");
	assert(abs(nbtDouble.value - 5.5) < 0.01);

	NBTByteArray nbtBytes = new NBTByteArray();
	nbtBytes.decode(cast(ubyte[])[7, 0, 0] ~ cast(ubyte[])nativeToBigEndian(cast(int)4) ~ cast(ubyte[])[1, 2, 42, 33], false);
	assert(nbtBytes.name == "");
	assert(nbtBytes.value == cast(byte[])[1, 2, 42, 33]);

	NBTString nbtText = new NBTString();
	nbtText.decode(cast(ubyte[])[8, 0, 0] ~ cast(ubyte[])nativeToBigEndian(cast(short)11) ~ cast(ubyte[])"Hello World", false);
	assert(nbtText.name == "");
	assert(nbtText.value == "Hello World");

	NBTList nbtShorts = new NBTList();
	nbtShorts.decode(cast(ubyte[])[9, 0, 0, 2] ~ cast(ubyte[])nativeToBigEndian(cast(int)1) ~ cast(ubyte[])nativeToBigEndian(cast(short)5), false);
	assert(nbtShorts.name == "");
	assert(nbtShorts.value.length == 1);
	assert(nbtShorts.value[0].type == NBTType.Short, to!string(nbtShorts.value[0].type));
	assert(nbtShorts.get!NBTShort(0).value == 5);

	NBTCompound nbtCompound = new NBTCompound();
	nbtCompound.decode(cast(ubyte[])[10, 0, 0, 0], false);
	assert(nbtCompound.name == "");
	assert(nbtCompound.value.length == 0);

	NBTIntArray nbtInts = new NBTIntArray();
	nbtInts.decode(cast(ubyte[])[11, 0, 0] ~ cast(ubyte[])nativeToBigEndian(cast(int)2) ~ cast(ubyte[])nativeToBigEndian(5) ~ cast(ubyte[])nativeToBigEndian(555), false);
	assert(nbtInts.name == "");
	assert(nbtInts.value == [5, 555]);
}
