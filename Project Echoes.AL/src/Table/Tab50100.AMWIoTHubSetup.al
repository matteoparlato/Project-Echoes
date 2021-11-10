table 50100 "AMW IoT Hub Setup"
{
    Caption = 'AMW IoT Hub Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Hub Name"; Text[250])
        {
            Caption = 'Hub Name';
            DataClassification = ToBeClassified;
        }
        field(2; "SAS Token"; Text[250])
        {
            Caption = 'SAS Token';
            DataClassification = ToBeClassified;
        }
        field(3; "Enable Log"; Boolean)
        {
            Caption = 'Enable Log';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Hub Name")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        Helper: Codeunit "AMW IoT Hub Helper";
    begin
        Rec.TestField("Hub Name");
        Rec.TestField("SAS Token");
        Helper.SetDefaultEndpoints("Hub Name");
    end;

    trigger OnDelete()
    var
        Endpoint: Record "AMW IoT Hub Endpoint";
        Device: Record "AMW IoT Device";
    begin
        Endpoint.Reset();
        Endpoint.SetRange("Hub Name", "Hub Name");
        Endpoint.DeleteAll();

        Device.Reset();
        Device.SetRange("Hub Name", "Hub Name");
        Device.DeleteAll();
    end;
}
