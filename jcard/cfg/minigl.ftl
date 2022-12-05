<!doctype html>

<#setting number_format="###,###,##0.00">         

<html>
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

 <title>jCard</title>

 <style type="text/css">
   body {
    font-family: trebuchet ms, verdana, tahoma, arial, sans-serif;
    font-style: normal;
    color: #000000;
    background-color: #FFFFFF;
    margin-left: 10%;
    margin-right: 20%;
    padding:15px;
   }
   .section-header {
   }
   h1 {
     color:#CC6600;
     font-family:verdana,arial,sans-serif;
     font-size:16px;
     font-weight:bold;
   }
   h2 {
     color:#CC6600;
     font-family:verdana,arial,sans-serif;
     font-size:16px;
     font-weight:bold;
   }
   h3 {
     color:#CC6600;
     font-family:verdana,arial,sans-serif;
     font-size:14px;
     font-weight:bold;
   }

   li { padding-bottom: 1em; }
   li:first-line { font-weight: bold; }
   .imageright {
     float: right;
     margin: 0;
     padding: 0 0 0 3%;
   }
   .imageleft {
     float: left;
     margin: 0;
     padding: 0 2% 0 0;
   }
   a {
       text-decoration:none
   }
   a:visited{
       color:blue;
   }
   .even{
       background-color:#c0ffc0;
   }
 </style>
</head>

<body>
<a href="http://jpos.org"><img class="imageright" width="8%"
   src="http://jpos.org/images/jpos-consulting.jpg" border="0" alt="jPOS" /></a>

<h1><a name="top">jCard</a></h1>

<#macro recurse_chart node depth>
  <#assign index = index + 1>

  <tr onclick="window.location='#acct_${node.code}'"
         style="cursor:pointer;"
         onmouseover="bgColor='#D0D0D0'"
         onmouseout="<#if index % 2 == 0 > bgColor='#c0ffc0'<#else> bgColor='#FFFFFF'</#if>"
         <#if index % 2 == 0> bgcolor="#c0ffc0"</#if>>
    <td align='left'>
      <#if (depth>0) >
        <#list 1..depth as i>&nbsp;&nbsp;</#list>
      </#if>
      <a href="#acct_${node.code}">${node.code} | ${node.description}</a>
    </td>
    <td align="right">
      <#assign balance = gls.getBalance(journal,node,layers) />
      <#if balance != 0>
        ${balance}
        <#if depth != 0>
         <#list 1..depth as i>&nbsp;&nbsp;&nbsp;&nbsp;</#list>
        </#if>
      </#if>
    </td>

    <!--
    <td align="right">
      <_assign balance = gls.getBalance(journal,node,JAN_2010,layers) />
      <#if balance != 0>
        ${balance}
        <#if depth != 0>
         <#list 1..depth as i>&nbsp;&nbsp;&nbsp;&nbsp;</#list>
        </#if>
      </#if>
    </td>
    <td align="right">
      <_assign balance = gls.getBalance(journal,node,DEC_2009,layers) />
      <#if balance != 0>
        ${balance}
        <#if depth != 0>
         <#list 1..depth as i>&nbsp;&nbsp;&nbsp;&nbsp;</#list>
        </#if>
      </#if>
    </td>
    -->

  </tr>
  <#if node.children??>
    <#list node.children as child>
      <@recurse_chart node=child depth=depth+1/>
    </#list>
 </#if>
</#macro>

<table border="1" cellpadding="1" cellspacing="1" width="100%">
    <caption><strong>Balance sheet</strong></caption>
    <tr>
        <th align="left"> Account </th>
        <th align="right"> Balance </th>
        <!--
        <th align="right"> January 2010 </th>
        <th align="right"> December 2009 </th>
        -->
    </tr>
<#assign index = 0>
<#list journal.chart.children as acct>
 <@recurse_chart node=acct depth=0 />
</#list>
</table>

<hr/>

<#macro state_of_account acctDetail>
  <h2><a name="acct_${acctDetail.account.code}">${acctDetail.account.code} / ${acctDetail.account.description}</a></h2>
<table width="100%">
  <thead>
   <tr>
     <th align="left" width="12%">Date</th>
     <th align="left" width="50%">Description</th>
     <th align="right">Debits</th>
     <th align="right">Credits</th>
     <th align="right">Balance</th>
   </tr>
  </thead>
  <tbody>
  <#if acctDetail.initialBalance.toString() != "0.00">
  <tr onmouseover="bgColor='#D0D0D0'" onmouseout="bgColor='#FFFFFF'">
    <td align="left">${acctDetail.start?string("dd/MM/yyyy")}</td>
    <td align="left"><strong>Initial balance</strong></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td align="right">${acctDetail.initialBalance}</td>
  </tr>
  </#if>

  <#list acctDetail.entries as entry>
   <tr <#if entry_index % 2 == 0> bgcolor="#c0ffc0"</#if> onclick="window.location='#txn_${entry.transaction.id}'"
         style="cursor:pointer;"
         onmouseover="bgColor='#D0D0D0'"
         onmouseout="<#if entry_index % 2 == 0 > bgColor='#c0ffc0'<#else> bgColor='#FFFFFF'</#if>">
     <td align="left" valign="top">${entry.transaction.postDate?string("dd/MM/yyyy")}</td>
     <td align="left" valign="top"><a href="#txn_${entry.transaction.id}" title="${entry.account.code} ${entry.account.description}">${entry.transaction.detail}<#if entry.detail??>, ${entry.detail}</#if></a></td>
     <#if entry.debit>
       <td align="right" valign="top">${entry.amount}</td>
       <td></td>
     <#else>
       <td></td>
       <td align="right" valign="top">${entry.amount}</td>
     </#if>
     <td align="right" valign="top">${entry.balance}</td>
   </tr>
  </#list>
  <tr>
    <td colspan="5"><hr/></td>
  </tr>
  <tr onmouseover="bgColor='#D0D0D0'" onmouseout="bgColor='#FFFFFF'">
    <td align="left"><strong>TOTALS</strong></td>
    <td>&nbsp;</td>
    <td align="right">${acctDetail.debits}</td>
    <td align="right">${acctDetail.credits}</td>
    <td align="right">${acctDetail.finalBalance}</td>
  </tr>
  </tbody>
</table>
  <br/>
  <br/>
  <p align="right"><a href="#top">Back to top</a></p>
  <hr/>
</#macro>

<#macro display_transaction txn layers>
  <h2>
    <a name="txn_${txn.id}">#${txn.id} | ${txn.postDate?string("dd/MM/yyyy")}</a>
  </h2>
  <table width="100%">
    <tr><th colspan="4" align="left">${txn.detail}</th></tr>
    <tr><td>&nbsp;</td></tr>
  <#assign index = 0 />
  <#list txn.entries as entry>
   <#if entry.hasLayers(layers)>
    <#assign index = index+1 />
    <tr <#if index % 2 == 0> bgcolor="#c0ffc0"</#if> onmouseover="bgColor='#D0D0D0'"
         onmouseout="<#if entry_index % 2 == 0 > bgColor='#c0ffc0'<#else> bgColor='#FFFFFF'</#if>">
      <td width="12%">${entry.account.code}<sub><font size="-2">${entry.layer?string.number}</font></sub></td>
      <td width="48%" >
          ${entry.account.description}
          ${entry.detail!}
      </td>
      <#if entry.debit>
        <td align="right" valign="top" width="20%">${entry.amount}</td>
        <td width="20%"></td>
      <#else>
        <td width="20%"></td>
        <td align="right" valign="top" width="20%">${entry.amount}</td>
      </#if>
    </tr>
   </#if>
  </#list>
   <#assign index = index+1 />
    <tr <#if index % 2 == 0> bgcolor="#c0ffc0"</#if> onmouseover="bgColor='#D0D0D0'"
     <td>&nbsp;</td>
     <td><strong>TOTALS</strong></td>
     <td>&nbsp;</td>
     <td align="right"><strong>${txn.getDebits(layers)}</strong></td>
     <td align="right"><strong>${txn.getCredits(layers)}</strong></td>
    </tr>
  </table>
  <hr/>
</#macro>

<table border="1" cellpadding="1" cellspacing="1" width="100%">
<caption align="center"><strong>Accounts details</strong></caption>
</table>
<#list allAccounts as acct>
   <#if acct.type != 0>
     <#assign acctDetail = gls.getAccountDetail(journal,acct,journal.getStart(), journal.getEnd(), layers) />
     <@state_of_account acctDetail=acctDetail />
   </#if>
</#list>

<table border="1" cellpadding="1" cellspacing="1" width="100%">
<caption align="center"><strong>Journal</strong></caption>
</table>
<#list transactions as txn>
 <#if txn.hasLayers(layers)>
  <@display_transaction txn=txn layers=layers />
 </#if>
</#list>

</body>
</html>

