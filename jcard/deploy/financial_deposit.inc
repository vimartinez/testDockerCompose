<participant class="org.jpos.jcard.FinancialRefund"
             logger="Q2" realm="financial-refund" enabled="${USE_INTERNAL_SOR:true}"/>
<participant class="org.jpos.jcard.ComputeBalances"
             logger="Q2" realm="compute-balances" enabled="${USE_INTERNAL_SOR:true}">
<property name="checkpoint" value="compute-balances" />
</participant>
