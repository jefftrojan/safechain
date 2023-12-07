import Principal "mo:base/Principal";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";

actor MedicalRecordManager {

    type MedicalRecord = {
        userPrincipal : Principal;
        medicalCase : Text;
        date : Text;
        treatment : Text;
    };

    var records = HashMap.HashMap<Nat, MedicalRecord>(1, Nat.equal, Hash.hash);

    stable var recordIdCount : Nat = 0;

    public func addRecord(record: MedicalRecord): async () {
        // Auth

        // Prepare data
        let id : Nat = recordIdCount;
        recordIdCount += 1;

        // Add record
        records.put(id, record);

        // Return confirmation
        ();
    };

    public query func getRecord(id: Nat): async ?MedicalRecord {
        // Auth

        // Query data
        let recordRes : ?MedicalRecord = records.get(id);

        // Return requested record or null
        return recordRes;
    };

    public func updateRecord(record: MedicalRecord, id: Nat): async Text {
        // Auth

        // Query data
        let recordRes : ?MedicalRecord = records.get(id);

        // Validate answer
        switch (recordRes) {
            case (null) {
                return "Nonexistent record";
            };
            case (?currentRecord) {
                let updatedRecord : MedicalRecord = {
                    userPrincipal = currentRecord.userPrincipal;
                    medicalCase = record.medicalCase;
                    date = record.date;
                    treatment = record.treatment;
                };

                // Update
                records.put(id, updatedRecord);

                // Return success
                return "Update successful";
            };
        };
    };

    public func removeRecord(id: Nat): async Text {
        // Auth

        // Query data
        let recordRes : ?MedicalRecord = records.get(id);

        // Validate if exists
        switch (recordRes) {
            case (null) {
                // Return
                return "Nonexistent record";
            };
            case (_) {
                // Remove record
                ignore records.remove(id);

                // Return success
                return "Successfully deleted";
            };
        };
    };
};