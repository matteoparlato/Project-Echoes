page 50103 "AMW IoT Direct Method"
{
    Caption = 'Direct Method';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Name/Value Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = false;

                field(HubName; GlobalDevice."Hub Name")
                {
                    ApplicationArea = All;
                    Caption = 'Hub Name';
                    Enabled = false;
                }
                field(DeviceName; GlobalDevice."Device ID")
                {
                    ApplicationArea = All;
                    Caption = 'Device ID';
                    Enabled = false;
                }
                field(GlobalMethodName; GlobalMethodName)
                {
                    ApplicationArea = All;
                    Caption = 'Method Name';
                    ShowMandatory = true;
                }
                field(GlobalPayload; GlobalPayload)
                {
                    ApplicationArea = All;
                    Caption = 'Payload';
                    MultiLine = true;
                    ShowMandatory = true;
                }
                field(GlobalResponse; GlobalResponse)
                {
                    ApplicationArea = All;
                    Caption = 'Response';
                    Editable = false;
                    MultiLine = true;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Invoke")
            {
                ApplicationArea = All;
                Image = Action;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Hub: Record "AMW IoT Hub Setup";
                    Service: Codeunit "AMW IoT Hub Client";
                    ResponseMessage: HttpResponseMessage;
                    ResponseContent: Text;
                begin
                    Clear(GlobalNotification);
                    Clear(GlobalResponse);

                    Hub.Get(GlobalDevice."Hub Name");
                    Service.InitializeClient(Hub."SAS Token");
                    if Service.InvokeMethod(GlobalDevice, GlobalMethodName, GlobalPayload, ResponseMessage) then
                        GlobalNotification.Message(StrSubstNo(InvokeSuccessMsg, GlobalMethodName, GlobalDevice."Device ID"))
                    else
                        GlobalNotification.Message(StrSubstNo(InvokeErrorMsg, GlobalMethodName, GlobalDevice."Device ID"));
                    GlobalNotification.Send();

                    ResponseMessage.Content().ReadAs(ResponseContent);
                    GlobalResponse := ResponseContent;
                end;
            }
        }
    }

    var
        GlobalDevice: Record "AMW IoT Device";
        GlobalMethodName: Text;
        GlobalPayload: Text;
        GlobalResponse: Text;
        GlobalNotification: Notification;
        InvokeSuccessMsg: Label 'Successfully invoked direct method %1 on %2!';
        InvokeErrorMsg: Label 'An error occured while invoking direct method %1 on %2. Please check if the device is enabled and connected.';

    procedure SetDevice(Device: Record "AMW IoT Device")
    begin
        GlobalDevice := Device;
    end;
}
