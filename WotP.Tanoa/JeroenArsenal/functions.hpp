
class JN {
	class JNA {
		file = "JeroenArsenal\JNA";
		class arsenal {};
		class arsenal_addItem {};
		class arsenal_addToArray {};
		class arsenal_cargoToArray {};
		class arsenal_cargoToArsenal {};
		class arsenal_init {};
		class arsenal_inList {};
		class arsenal_itemCount {};
		class arsenal_itemType {};
		class arsenal_loadInventory {};
		class arsenal_removeFromArray {};
		class arsenal_removeItem {};
		class arsenal_requestOpen {};
		class arsenal_requestClose {};
		class vehicleArsenal {};

	};
	class JNG {
		file = "JeroenArsenal\JNG";
		class garage {};
		class garage_addVehicle {};
		class garage_init {};
		class garage_releaseVehicle {};
		class garage_removeVehicle {};
		class garage_requestOpen {};
		class garage_requestClose {};
		class garage_requestVehicle {};
		class garage_getVehicleIndex {};
		class garage_getVehicleData {};
		class garage_garageVehicle {};
		class garage_canGarageVehicle {};
	};

	class JNL {
		file = "JeroenArsenal\JNL";
		class logistics_init {};
		class logistics_load {};
		class logistics_unLoad {};
		class logistics_addAction {};
		class logistics_removeAction {};
	};

	class JNL_Actions {
		file = "JeroenArsenal\JNL\Actions";
		class logistics_addActionGetInWeapon {};
		class logistics_addActionLoad {};
		class logistics_addActionUnload {};
		class logistics_addEventGetOutWeapon {};
		class logistics_removeActionGetInWeapon {};
		class logistics_removeActionLoad {};
		class logistics_removeActionUnload {};
		class logistics_removeEventGetOutWeapon {};
	};

	class JNL_Functions {
		file = "JeroenArsenal\JNL\Functions";
		class logistics_canLoad {};
		class logistics_getCargo {};
		class logistics_getCargoOffsetAndDir {};
		class logistics_getCargoType {};
		class logistics_getNodes {};
		class logistics_lockSeats {};
	};
};