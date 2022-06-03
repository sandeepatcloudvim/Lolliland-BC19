pageextension 54502 "LOLI Posted Sales Invoice Ext." extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Posting Date")
        {
            field("LOLI Adjusted Profit Amt"; Rec."LOLI_Adjusted Profit Amt")
            {
                ToolTip = 'Specifies the value of the Adjusted Profit field.';
                ApplicationArea = All;
            }
            field("LOLI Adjusted Profit Per"; Rec."LOLI_Adjusted Profit Per")
            {
                ToolTip = 'Specifies the value of the Adjusted Profit % field.';
                ApplicationArea = All;
            }
            field(LOLI_Volume; Rec."LOLI_Volume")
            {
                ApplicationArea = All;
                Caption = 'Volume';
            }
            field("LOLI_Gross Weight"; Rec."LOLI_Gross Weight")
            {
                ApplicationArea = All;
                Caption = 'Gross Weight';
            }
            field("LOLI_No. of Pallet Height"; Rec."LOLI_No. of Pallet Height")
            {
                ApplicationArea = All;
                Caption = 'No. of Pallet Height';
                Visible = false;
            }
            field("LOLI_No. of Pallet Weight"; Rec."LOLI_No. of Pallet Weight")
            {
                ApplicationArea = All;
                Caption = 'No. of Pallet Weight';
                Visible = false;
            }
            field("LOLI_Pallet Total"; Rec."LOLI_Pallet Total")
            {
                ApplicationArea = All;
                Caption = 'Pallet Total';
            }
            field("Ship-to County"; Rec."Ship-to County")
            {
                ApplicationArea = All;
                Caption = 'State';
            }
        }
    }


    local procedure CalcAdjustProfit()
    var
        CostCalcMgt: Codeunit "Cost Calculation Management";
        TaxArea: Record "Tax Area";
        Currency: Record Currency;
        SalesInvLine: Record "Sales Invoice Line";
        CustAmount: Decimal;
        TotalAdjCostLCY: Decimal;
        AmountLCY: Decimal;
        CurrExchRate: Record "Currency Exchange Rate";
        AdjProfitLCY: Decimal;
        AdjProfitPct: Decimal;
        SalesRecv: Record "Sales & Receivables Setup";
    begin
        Clear(SalesInvLine);
        Clear(CustAmount);
        Clear(TotalAdjCostLCY);
        Clear(AmountLCY);
        Clear(AdjProfitLCY);
        Clear(AdjProfitPct);
        if TaxArea.Get(Rec."Tax Area Code") then;
        if SalesRecv.Get() then;

        if Rec."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else
            Currency.Get(Rec."Currency Code");

        SalesInvLine.SetRange("Document No.", Rec."No.");
        if SalesInvLine.Find('-') then
            repeat
                CustAmount := CustAmount + SalesInvLine.Amount;
                TotalAdjCostLCY := TotalAdjCostLCY + CostCalcMgt.CalcSalesInvLineCostLCY(SalesInvLine);
            until SalesInvLine.Next = 0;

        if Rec."Currency Code" = '' then
            AmountLCY := CustAmount
        else
            AmountLCY :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                WorkDate, Rec."Currency Code", CustAmount, Rec."Currency Factor");

        AdjProfitLCY := AmountLCY - TotalAdjCostLCY;
        if AmountLCY <> 0 then
            AdjProfitPct := Round(100 * AdjProfitLCY / AmountLCY, 0.1);

        Rec."LOLI_Adjusted Profit Amt" := AdjProfitLCY;
        Rec."LOLI_Adjusted Profit Per" := AdjProfitPct;

        if SalesInvLine."Unit Volume" > 0 then begin
            if SalesRecv."LOLI_Pallet Volume Formula" <> 0 then
                Rec."LOLI_No. of Pallet Height" := (SalesInvLine."Unit Volume" / SalesRecv."LOLI_Pallet Volume Formula")
            else
                Rec."LOLI_No. of Pallet Height" := (SalesInvLine."Unit Volume" / 2.9)
        end;

        if SalesInvLine."Gross Weight" > 0 then begin
            if SalesRecv."LOLI_Pallet Weight Formula" <> 0 then
                Rec."LOLI_No. of Pallet Weight" := (SalesInvLine."Gross Weight" / SalesRecv."LOLI_Pallet Weight Formula")
            else
                Rec."LOLI_No. of Pallet Weight" := (SalesInvLine."Gross Weight" / 1020)
        end;

        if (Rec."LOLI_No. of Pallet Height" <= Rec."LOLI_No. of Pallet Weight") then
            Rec."LOLI_Pallet Total" := Rec."LOLI_No. of Pallet Weight"
        else
            Rec."LOLI_Pallet Total" := Rec."LOLI_No. of Pallet Height";
    end;

    trigger OnAfterGetRecord()
    begin
        CalcAdjustProfit;
    end;
}
