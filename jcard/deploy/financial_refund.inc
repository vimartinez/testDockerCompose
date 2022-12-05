<participant class="org.jpos.jcard.PendingCredit" logger="Q2" realm="financial-refund" enabled="${USE_INTERNAL_SOR:true}">
    <property name="layer-offset" value="0" />
    <property name="ok-code" value="0000" />
    <property name="checkpoint" value="financial-refund" />
</participant>
<participant class="org.jpos.jcard.ComputeBalances"
             logger="Q2" realm="compute-balances" enabled="${USE_INTERNAL_SOR:true}">
<property name="checkpoint" value="compute-balances" />
</participant>
