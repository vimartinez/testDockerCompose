<participant class="org.jpos.jcard.Authorization"
             logger="Q2" realm="authorization" enabled="${USE_INTERNAL_SOR:true}">
    <property name="checkpoint"   value="authorization" />
    <property name="partial"   value="true" />
</participant>

<participant class="org.jpos.jcard.ComputeBalances"
             logger="Q2" realm="compute-balances" enabled="${USE_INTERNAL_SOR:true}">
<property name="checkpoint" value="compute-balances" />
</participant>
