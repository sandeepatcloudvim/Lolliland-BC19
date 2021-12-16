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
    begin
        Clear(SalesInvLine);
        Clear(CustAmount);
        Clear(TotalAdjCostLCY);
        Clear(AmountLCY);
        Clear(AdjProfitLCY);
        Clear(AdjProfitPct);
        if TaxArea.Get(Rec."Tax Area Code") then;

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
    end;

    trigger OnAfterGetRecord()
    begin
        CalcAdjustProfit;
    end;
}
