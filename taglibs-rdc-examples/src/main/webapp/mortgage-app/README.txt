***************************************************************************
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
****************************************************************************
This directory contains the RDC based JSPs for the mortgage sample
application.

The starting point for this application is:
./login.jsp

The sample application uses the following fictitious scenario for getting 
quotes/setting up a home mortgage:
1) Login - Asks user for a member number and the MLS number of
   the property of interest.
2) Mortgage details - After prompting the user with the value of the
   property specified by the MLS number, the user is asked to provide
   details for the type of mortgage, and percentage down payment.
3) Quote - The user is provided with a quote, and the choice to accept
   or reject it.

This sample application only provides placeholders for the property value
and the quote without using any backend. This also means the user may 
provide any member number or MLS number between 2 and 9 digits long.
