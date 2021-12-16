tableextension 54502 "LOLI_ExtendSalesHeader" extends "Sales Header"
{
    fields
    {
        field(54500; "LOLI_Adjusted Profit Amt"; Decimal)
        {
            Caption = 'Adjusted Profit';
            DataClassification = ToBeClassified;
        }
        field(54501; "LOLI_Adjusted Profit Per"; Decimal)
        {
            Caption = 'Adjusted Profit %';
            DataClassification = ToBeClassified;
        }
    }
}
