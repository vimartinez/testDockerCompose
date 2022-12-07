package org.jpos.simulator;

import org.jpos.iso.ISOException;
import org.jpos.iso.ISOUtil;
//carpeta packager desde ss-visa
import packager.DataSet;
import packager.DataSetField;

/**
 * @author Arturo Volpe
 * @since 2022-01-10
 */
public class TLVFieldBuilder {

    private final DataSetField field;

    TLVFieldBuilder() {
        this.field = new DataSetField();
    }

    public static TLVFieldBuilder create() {
        return new TLVFieldBuilder();
    }

    public TLVFieldBuilder set(int usage, String fieldHex, String valueAscii) {
        DataSet ds = this.field.getDataSet(Integer.toHexString(usage));
        if (ds == null) {
            ds = new DataSet(usage);
            this.field.add(ds);
        }
        ds.add(ISOUtil.hex2byte(fieldHex)[0], ISOUtil.asciiToEbcdic(valueAscii));
        return this;
    }

    public String packVISA() throws ISOException {
        return ISOUtil.byte2hex(field.pack());
    }
}
