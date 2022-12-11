/*
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
 */
package org.apache.taglibs.rdc;

import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

import org.apache.taglibs.rdc.core.BaseModel;

/**
 * Datamodel for the digits RDC. The digits RDC will be associated
 * with the digits(0...9), the maximum and minimum
 * length within which the input's length must lie, and a pattern to
 * which the input must conform.
 *
 * @author Sindhu Unnikrishnan
 * @author Rahul Akolkar
 */

public class Digits extends BaseModel {
    // The digits RDC will be associated with the digits,
    // the maximum and minimum length within
    // which the input's length must lie, and a pattern to which
    // the input must conform.

    // Serial Version UID
    private static final long serialVersionUID = 1L;
    // Maximum allowed length of the input; -1 indicates
    // no constraint on maximum length
    private int minLength;
    // Minimum allowed length of the input; -1 indicates
    // no constraint on minimum length
    private int maxLength;
    // The digits input must conform to this pattern
    private String pattern;

    // Error codes, defined in configuration file
    /**A constant for Error Code stating Invalid digit */
    public static final int ERR_INVALID_DIGIT = 1;

    /**A constant for Error Code stating the digit entered is
     * larger than allowed */
    public static final int ERR_NEED_SHORTER_DIGIT = 2;

    /**A constant for Error Code stating the digit entered is
      * smaller than allowed */
    public static final int ERR_NEED_LONGER_DIGIT = 3;

    /**
     * Sets default values for all data members
     */
    public Digits() {
        super();
        this.minLength = -1;
        this.maxLength = -1;
        // Default pattern allows any combination of digits
        this.pattern = "[0-9]*";
    }

    /**
     * Gets the maximum allowed length of input
     *
     * @return the maximum allowed length of input
     */
    public String getMaxLength() {
        return String.valueOf(maxLength);
    }

    /**
     * Sets the maximum allowed length of digit
     *
     * @param maxLength the maximum allowed length of digit
     */
    public void setMaxLength(String maxLength) {
        if (maxLength != null) {
            try {
                this.maxLength = Integer.parseInt(maxLength);
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("maxLength attribute " +
                    "of \"" + getId() + "\" digit tag is not a number.");
            }
        }
    }

    /**
     * Gets the minimum allowed length of input
     *
     * @return the minimum allowed length of input
     */
    public String getMinLength() {
        return String.valueOf(minLength);
    }

    /**
     * Sets the minimum allowed length of input
     *
     * @param minLength the minimum allowed length of input
     */
    public void setMinLength(String minLength) {
        if (minLength != null) {
            try {
                this.minLength = Integer.parseInt(minLength);
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("minLength attribute " +
                    "of \"" + getId() + "\" digit tag is not a number.");
            }
        }
    }

    /**
     * Gets the pattern string
     *
     * @return the pattern string
     */
    public String getPattern() {
        return this.pattern;
    }
    
    /**
     * Sets the pattern string to which the input must conform
     *
     * @param pattern the pattern string to which the input must conform
     */
    public void setPattern(String pattern) {
        if (pattern != null) {
            try {
                Pattern.compile(pattern);
                this.pattern = pattern;
            } catch (PatternSyntaxException e) {
                throw new IllegalArgumentException( "pattern attribute " +
                    "of \"" + getId() + "\" digit tag not in proper format.");
            }
        }
    }

    /**
     * Validates the input against the given constraints
     *
     * @return TRUE if valid, FALSE otherwise
     */
    protected Boolean validate(Object newValue, boolean setErrorCode) {

        if (pattern != null) {
            if (!(Pattern.matches(pattern, (String) newValue))) {
                if (setErrorCode) setErrorCode(ERR_INVALID_DIGIT);
                return Boolean.FALSE;
            }
        }
        if (maxLength > 0) {
            if (((String) newValue).length() > maxLength) {
                if (setErrorCode) setErrorCode(ERR_NEED_SHORTER_DIGIT);
                return Boolean.FALSE;
            }
        }
        if (minLength > 0) {
            if (((String) newValue).length() < minLength) {
                if (setErrorCode) setErrorCode(ERR_NEED_LONGER_DIGIT);
                return Boolean.FALSE;
            }
        }
        return Boolean.TRUE;
    }
}
