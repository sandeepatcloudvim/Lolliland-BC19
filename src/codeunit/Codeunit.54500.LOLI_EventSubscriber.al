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


    //AGT_DS_21042022++
    [EventSubscriber(ObjectType::Report, report::"Get Source Documents", 'OnAfterSalesLineOnPreDataItem', '', true, true)]
    local procedure CheckReasonCode(VAR SalesLine: Record "Sales Line"; OneHeaderCreated: Boolean; WhseShptHeader: Record "Warehouse Shipment Header"; WhseReceiptHeader: Record "Warehouse Receipt Header")
    begin
        SalesLine.SetRange("Return Reason Code", '');
    end;
    //AGT_DS_21042022--
    //AGT_DS_28042022++
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnCopyToTempLinesOnAfterSetFilters', '', true, true)]
    local procedure OnCopyToTempLinesOnAfterSetFilters(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        ItemTempl: Record "Item Templ.";
    begin
        SalesLine.SetRange("Return Reason Code", '');
    end;
    //AGT_DS_28042022--
}