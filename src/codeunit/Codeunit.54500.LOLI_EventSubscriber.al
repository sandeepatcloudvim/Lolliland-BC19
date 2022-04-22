codeunit 54500 "LOLI_EventSubscriber"
{

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Templ. Mgt.", 'OnApplyTemplateOnBeforeItemModify', '', true, true)]
    local procedure UpdateCustomField(var Item: Record Item; ItemTempl: Record "Item Templ.")
    begin
        Item."Put-away Unit of Measure Code" := ItemTempl."LOLI_Put-away Unit of Measure";
        Item."Bulk Unit of Measure" := ItemTempl."LOLI_Bulk Unit of Measure";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Templ. Mgt.", 'OnInsertTemplateFromItemOnBeforeItemTemplInsert', '', true, true)]
    local procedure UpdateCustomFields(var ItemTempl: Record "Item Templ."; Item: Record Item)
    begin
        ItemTempl."LOLI_Sales Unit of Measure" := Item."Sales Unit of Measure";
        ItemTempl."LOLI_Purch. Unit of Measure" := Item."Purch. Unit of Measure";
        ItemTempl."LOLI_Put-away Unit of Measure" := Item."Put-away Unit of Measure Code";
        ItemTempl."LOLI_Bulk Unit of Measure" := Item."Bulk Unit of Measure";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Templ. Mgt.", 'OnAfterFillFieldExclusionList', '', true, true)]
    local procedure UpdateCustomFieldsValues(var FieldExclusionList: List of [Integer])
    var
        ItemTempl: Record "Item Templ.";
    begin
        FieldExclusionList.Add(ItemTempl.FieldNo("LOLI_Sales Unit of Measure"));
        FieldExclusionList.Add(ItemTempl.FieldNo("LOLI_Purch. Unit of Measure"));
        FieldExclusionList.Add(ItemTempl.FieldNo("LOLI_Put-away Unit of Measure"));
        FieldExclusionList.Add(ItemTempl.FieldNo("LOLI_Bulk Unit of Measure"));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Sell-to Customer No.', true, true)]
    local procedure UpdateSalesOrder(var Rec: Record "Sales Header")
    var
        recSalesHeader: Record "Sales Header";
    begin
        recSalesHeader.RESET;
        recSalesHeader.SETFILTER("Document Type", '%1', recSalesHeader."Document Type"::Order);
        recSalesHeader.SETRANGE("Sell-to Customer No.", Rec."Sell-to Customer No.");
        recSalesHeader.SetFilter("Order Date", '%1..%2', CalculateBusinessBackDays(WorkDate() + 1), WORKDATE);
        IF NOT recSalesHeader.FindLast() THEN
            EXIT
        ELSE begin
            if Not Confirm('Already there is Sales order exist for this customer, do you want to create new one ?') then begin
                if not (recSalesHeader.Status = recSalesHeader.Status::Open) then
                    recSalesHeader.Validate(Status, recSalesHeader.Status::Open);
                Rec := recSalesHeader;
            end;
        end;
    end;



    procedure CalculateBusinessBackDays(Wdate: date): Date
    var
        CompanyInformation: Record "Company Information";
        i: Integer;
        Desc: Text[150];
        newWorkDate: Date;
        BDays: Integer;
        CalendarMgmt: Codeunit "Calendar Management";
        CustomizedCalendarChange: Record "Customized Calendar Change";
    begin
        BDays := 0;
        CompanyInformation.GET;
        FOR i := 1 TO 20 DO BEGIN
            newWorkdate := CALCDATE('<-1D>', wDate);
            IF NOT CheckDateStatus(CompanyInformation."Base Calendar Code", newWorkdate, Desc) THEN
                BDays += 1;
            wDate := newWorkdate;
            IF BDays = 10 THEN
                EXIT(newWorkdate);
        END;
    end;

    procedure CheckDateStatus(CalendarCode: Code[10]; TargetDate: Date; VAR Description: Text[50]): Boolean
    var
        BaseCalChange: Record "Base Calendar Change";
    begin
        BaseCalChange.RESET;
        BaseCalChange.SETRANGE("Base Calendar Code", CalendarCode);
        IF BaseCalChange.FINDSET THEN
            REPEAT
                CASE BaseCalChange."Recurring System" OF
                    BaseCalChange."Recurring System"::" ":
                        IF TargetDate = BaseCalChange.Date THEN BEGIN
                            Description := BaseCalChange.Description;
                            EXIT(BaseCalChange.Nonworking);
                        END;
                    BaseCalChange."Recurring System"::"Weekly Recurring":
                        IF DATE2DWY(TargetDate, 1) = BaseCalChange.Day THEN BEGIN
                            Description := BaseCalChange.Description;
                            EXIT(BaseCalChange.Nonworking);
                        END;
                    BaseCalChange."Recurring System"::"Annual Recurring":
                        IF (DATE2DMY(TargetDate, 2) = DATE2DMY(BaseCalChange.Date, 2)) AND
                           (DATE2DMY(TargetDate, 1) = DATE2DMY(BaseCalChange.Date, 1))
                        THEN BEGIN
                            Description := BaseCalChange.Description;
                            EXIT(BaseCalChange.Nonworking);
                        END;
                END;
            UNTIL BaseCalChange.NEXT = 0;
        Description := '';
    end;

    [EventSubscriber(ObjectType::Report, report::"Get Source Documents", 'OnAfterSalesLineOnPreDataItem', '', true, true)]
    local procedure CheckReasonCode(VAR SalesLine: Record "Sales Line"; OneHeaderCreated: Boolean; WhseShptHeader: Record "Warehouse Shipment Header"; WhseReceiptHeader: Record "Warehouse Receipt Header")
    begin
        SalesLine.SetRange("Return Reason Code", '');
    end;


}