import nbtd;

import std.bitmanip;
import std.math;
import std.conv;

unittest
{
	NBTCompound nbtCompound = new NBTCompound();
	nbtCompound.name = "player";
	nbtCompound["health"] = new NBTInt(1000);
	nbtCompound["upgrades"] = new NBTCompound([new NBTByte(1, "weapon"), new NBTByte(0, "health")]);

	NBTCompound copy = new NBTCompound();
	copy.decode(nbtCompound.encode());

	assert(copy.name == "player");
	assert(copy["health"].asInt().value == 1000);
	assert(copy["upgrades"].asCompound()["weapon"].asByte().value == 1);
	assert(copy["upgrades"].asCompound()["health"].asByte().value == 0);
}
