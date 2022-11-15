<participant class="org.jpos.jpts.PrepareContext" logger="Q2" realm="PrepareContext">
  <property name="trace" value="true" />
 </participant>

 <participant class="org.jpos.transaction.Open" logger="Q2" realm="open">
  <property name="checkpoint" value="open" />
  <property name="timeout" value="300" />
 </participant>

