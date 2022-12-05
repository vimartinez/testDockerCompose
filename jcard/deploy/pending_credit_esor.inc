<participant class="org.jpos.jcard.esor.GenerateUniqueTxnId" enabled="${USE_EXTERNAL_SOR:false}"/>
<participant class="org.jpos.jcard.esor.PrepareExternalSORRequest" enabled="${USE_EXTERNAL_SOR:false}"/>
<participant class="org.jpos.aws.xray.QueryHostXRayAware" logger="Q2" realm="query-host"
             enabled="${USE_EXTERNAL_SOR:false}">
<property name="request" value="DS_REQUEST"/>
<property name="response" value="DS_RESPONSE"/>
</participant>
<participant class="org.jpos.jcard.esor.ProcessExternalSORResponse" enabled="${USE_EXTERNAL_SOR:false}"/>

<participant class="org.jpos.jcard.PendingCreditEsor" enabled="${USE_EXTERNAL_SOR:false}">
    <property name="layer-offset" value="6000" />
    <property name="checkpoint" value="pending-credit" />
</participant>
