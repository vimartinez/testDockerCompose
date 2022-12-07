package packager;

import org.jpos.iso.IFB_LLHBINARY;
import org.jpos.iso.ISOComponent;

/**
 * ISOFieldPackager Binary Hex LLBINARY
 *
 * @author apr@cs.com.uy
 * @version $Id$
 * @see ISOComponent
 */
public class IFB_LLHDataSet extends IFB_LLHBINARY {
    public IFB_LLHDataSet() {
        super();
    }

    /**
     * @param len         - field len
     * @param description symbolic descrption
     */
    public IFB_LLHDataSet(int len, String description) {
        super(len, description);
    }

    @Override
    public ISOComponent createComponent(int fieldNumber) {
        return new DataSetField(fieldNumber);
    }
}
