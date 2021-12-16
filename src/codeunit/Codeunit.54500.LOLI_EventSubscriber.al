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



}