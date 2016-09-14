package com.sabertazimi.tao.analysis;

/**
 * Created by sabertazimi on 16-9-14.
 */

import java.util.HashSet;
import com.sabertazimi.tao.analysis.Token.Type;

public class TerminalSymbol {

    /*
     * 在定义终结符的时候，为每一个 Sign 单独归于一个类型
     * 同样适用于 Keyword 类型
     * Parser 在识别它们的时候
     * 不仅要考虑它们的 type
     * 还要考虑它们的 value
     */
    @SuppressWarnings("serial")
    private final static HashSet<Type> careValueTypeSet = new HashSet<Type>() {{
        add(Type.Keyword);
        add(Type.Sign);
    }};

    // epsilon
    static final TerminalSymbol Empty = new TerminalSymbol(null, null);

    public final Type type;
    public final String value;
    final boolean careValue;

    TerminalSymbol(Type type, String value) {
        this.type = type;
        this.value = value;
        this.careValue = careValueTypeSet.contains(type);
    }

    boolean isEmpty() {
        return this.type == null;
    }

    @Override
    public boolean equals(Object obj) {
        boolean isEquals = false;
        if(obj instanceof TerminalSymbol) {
            TerminalSymbol other = (TerminalSymbol) obj;
            isEquals = isEquals(this.type, other.type);
            if(isEquals & careValue) {
                isEquals = isEquals(this.value, other.value);
            }
        }
        return isEquals;
    }

    private boolean isEquals(Object o1, Object o2) {
        boolean isEquals = false;
        if(o1 == null & o2 == null) {
            isEquals = true;
        } else if(o1 != null & o2 != null) {
            isEquals = o1.equals(o2);
        }
        return isEquals;
    }

    @Override
    public int hashCode() {
        int hashCode = getHashCode(this.type);
        if(careValue) {
            hashCode ^= getHashCode(this.value);
        }
        return hashCode;
    }

    private int getHashCode(Object obj) {
        int hashCode = 0;
        if(obj != null) {
            hashCode = obj.hashCode();
        }
        return hashCode;
    }

    @Override
    public String toString() {
        String str;
        if(this.value != null) {
            str = " “" + this.value + "”";
        } else {
            if(this.type != null) {
                str = this.type.toString();
            } else {
                str = "ε";
            }
        }
        return str;
    }
}