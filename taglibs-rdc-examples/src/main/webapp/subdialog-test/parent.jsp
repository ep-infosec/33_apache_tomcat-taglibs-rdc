<!--Example:Start-->
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
<!--
<%@ page language="java" contentType="application/voicexml+xml" %>
-->
<vxml version="2.0" xml:lang="en-US" xmlns="http://www.w3.org/2001/vxml">
  <form>
    <subdialog name="ccInfoSubdialog" src="subdialog.jsp">
      <filled>
        <script src="${pageContext.request.contextPath}/.grammar/return.js"/>
        <var name="ccData" expr="deserializeReturnValue(ccInfoSubdialog.ccInfo)"/>
        <prompt>
          The credit card is a <value expr="ccData.get('type')"/> card
          with number <value expr="ccData.get('number')"/>, has an expiry date of
          <value expr="ccData.get('expiry')"/> and the security code for this 
          card is <value expr="ccData.get('securityCode')"/> 
        </prompt>
      </filled> 
    </subdialog>
  </form>
</vxml>
<!--Example:End-->
