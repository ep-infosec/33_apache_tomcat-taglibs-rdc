<%--
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
--%>
<%--$Id$--%>
<!--
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="rdc" uri="http://jakarta.apache.org/taglibs/rdc-1.1" %>

<%@ tag body-content="empty" %>

<%@ attribute name="id" required="true" rtexprvalue="false" %>
<%@ attribute name="submit" required="false" %>
<%@ attribute name="config" required="false" %>
<%@ attribute name="initial" required="false" %>
<%@ attribute name="confirm" required="false" %>
<%@ attribute name="echo" required="false" %>
<%@ attribute name="locale" required="false" %>
<%@ attribute name="minConfidence" required="false" %>
<%@ attribute name="numNBest" required="false" %>
<%@ attribute name="maxNoInput" required="false" %>
<%@ attribute name="maxNoMatch" required="false" %>
<%@ attribute name="subdialog" required="false" %>
<%@ variable name-from-attribute="id" alias="retVal" scope="AT_END"%>
-->

<rdc:comment>
  Description: Collect, validate and confirm a state.
  Attributes:
  id: unique identifier for the atom
  submit: the submit location
  config: the configuration file location 
  initial: initial value
  confirm: boolean value indicating whether the input should be confirmed 
  echo: boolean value indicating whether to echo back the result on completion
</rdc:comment>

<rdc:peek var="stateMap" stack="${requestScope.rdcStack}"/>

<rdc:comment>
  Bean model holds the private data model of this component.
  It is created when the component is called the first time,
  and is found in subsequent requests  in stateMap[id].
</rdc:comment>
<jsp:useBean id="constants" class="org.apache.taglibs.rdc.core.Constants" />

<c:choose>
  <c:when test="${empty stateMap[id]}">
    <rdc:comment>This instance is being called for the first time in 
    this session</rdc:comment>
    <jsp:useBean id="model" class="org.apache.taglibs.rdc.CreditCardType" >
      <c:set target="${model}" property="state"
      value="${stateMap.initOnlyFlag == true ? constants.FSM_INITONLY : constants.FSM_INPUT}"/>
      <rdc:comment>initialize bean from our attributes</rdc:comment>
      <c:set target="${model}" property="id" value="${id}"/>
      <c:set target="${model}" property="confirm" value="${confirm}"/>
      <c:set target="${model}" property="echo" value="${echo}"/>
      <c:set target="${model}" property="initial" value="${initial}"/>
      <c:set target="${model}" property="locale" value="${locale}"/>
      <c:set target="${model}" property="subdialog" value="${subdialog}"/>
      <rdc:set-grammar model="${model}" key="rdc.creditcard.type.voicegrammar.uri" />
      <rdc:get-resource bundle="${model.rdcResourceBundle}" var="defaultConfig"
       key="rdc.creditcard.type.defaultconfig.uri" />
      <rdc:configure model="${model}" config="${config}"
       defaultConfig="${defaultConfig}" />
      <rdc:setup-results model="${model}" submit="${submit}" 
        minConfidence="${minConfidence}" numNBest="${numNBest}"
        maxNoInput="${maxNoInput}" maxNoMatch="${maxNoMatch}" />
     </jsp:useBean>
    <rdc:comment>cache away this instance for future requests in this 
    session</rdc:comment>
    <c:set target="${stateMap}" property="${id}" value="${model}"/>
  </c:when>
  <c:otherwise>
    <rdc:comment>retrieve cached bean for this instance</rdc:comment>
    <c:set var="model" value="${stateMap[id]}"/>
  </c:otherwise>
</c:choose>

<rdc:extract-params target="${model}" parameters="${model.paramsMap}"/>

<rdc:fsm-run  model="${model}"/>         

<c:if test="${model.state == constants.FSM_DONE}">
  <c:set var="retVal" value="${model.value}"/>
  <rdc:subdialog-return  model="${model}"/>
</c:if>
