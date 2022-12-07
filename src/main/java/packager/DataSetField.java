/*
 * jPOS Project [http://jpos.org]
 * Copyright (C) 2000-2020 jPOS Software SRL
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package packager;

import org.jpos.iso.ISOComponent;
import org.jpos.iso.ISOException;
import org.jpos.iso.ISOUtil;
import org.jpos.iso.packager.XMLPackager;
import org.jpos.util.Loggeable;

import java.io.InputStream;
import java.io.PrintStream;
import java.nio.ByteBuffer;
import java.util.Map;
import java.util.Map.Entry;
import java.util.TreeMap;

/**
 * An iso component that supports the VISA TLV format
 *
 * @author apr@cs.com.uy
 * @author avolpe@fintech.works
 */
public class DataSetField extends ISOComponent implements Loggeable {

    private int fieldNumber;
    private Map<String, DataSet> datasets;

    public DataSetField() {
        this.datasets = new TreeMap<>();
        this.fieldNumber = -1;
    }

    public DataSetField(final int fieldNumber) {
        this();
        this.fieldNumber = fieldNumber;
    }

    public void add(final DataSet ds) {
        this.datasets.put(ds.getIdAsHex(), ds);
    }

    public Map<String, DataSet> getDataSets() {
        return this.datasets;
    }

    @Override
    public void setFieldNumber(final int fieldNumber) {
        this.fieldNumber = fieldNumber;
    }

    @Override
    public int getFieldNumber() {
        return fieldNumber;
    }

    @Override
    public byte[] getBytes() throws ISOException {
        return this.pack();
    }

    @Override
    public void setValue(final Object obj) {
        if (obj instanceof byte[]) {
            this.unpack((byte[]) obj);
        } else {
            this.datasets = (Map<String, DataSet>) obj;
        }
    }

    @Override
    public Object getValue() {
        return this.getDataSets();
    }

    @Override
    public Object getKey() {
        return this.fieldNumber;
    }

    @Override
    public byte[] pack() throws ISOException {
        int l = 0;
        for (final Entry<String, DataSet> ds : this.datasets.entrySet()) {
            l += ds.getValue().length();
        }
        final ByteBuffer buf = ByteBuffer.allocate(l);
        for (final Entry<String, DataSet> ds : this.datasets.entrySet()) {
            buf.put(ds.getValue().pack());
        }
        return buf.array();
    }

    @Override
    public int unpack(final byte[] b) {
        this.datasets = new TreeMap<>();
        int consumed = 0;
        while (consumed < b.length) {
            final DataSet ds = new DataSet();
            consumed += ds.unpack(b, consumed);
            this.datasets.put(ds.getIdAsHex(), ds);
        }
        return consumed;
    }

    @Override
    public void dump(final PrintStream p, final String indent) {
        p.print(indent + "<!-- " + this.fieldNumber + "{");
        for (final Entry<String, DataSet> ds : this.datasets.entrySet()) {
            p.print(" ");
            p.print(ds.getValue().toString());
        }
        p.println("} -->");
        p.print(indent + "<" + XMLPackager.ISOFIELD_TAG + " " + XMLPackager.ID_ATTR + "=\"" + this.fieldNumber
                + "\" value=\"");
        try {
            p.print(ISOUtil.hexString(this.pack()));
        } catch (final ISOException e) {
            p.print(e.getMessage());
        }
        p.println("\" type=\"binary\" />");
    }

    @Override
    public void unpack(final InputStream in) throws ISOException {
        throw new ISOException("Not implemented");
    }

    /**
     * @return the ASCII value for the specified dataSet ID and TagId
     */
    public String getTagValueForDataSet(final String datasetId, final int tagId) {
        if (this.getDataSets().get(datasetId) != null) {
            return this.getDataSets().get(datasetId).getAsciiValueForTLV(tagId);
        }
        return null;
    }

    /**
     * @return the ASCII value for the specified dataSet ID and TagId, the tag id is in hexa, for example 80
     */
    public String getTagValueForDataSet(final String datasetId, final String hexaTag) {
        if (this.getDataSets().get(datasetId) != null) {
            return getTagValueForDataSet(datasetId, getTagFromHex(hexaTag));
        }
        return null;
    }

    /**
     * Will return true if the passed dataSetid is in the current list of datasets.
     */
    public boolean hasDataSet(final String dataSetId) {
        return this.getDataSets().containsKey(dataSetId);
    }

    /**
     * Returns the dataSet for the specific DatasetId)<br/>
     * <b>NOTE: the dataSetId has to be the hex value</b>
     */
    public DataSet getDataSet(final String dataSetId) {
        return this.getDataSets().get(dataSetId);
    }

    /**
     * Returns true if the specific tag, is in the dataset.
     */
    public boolean hasTagInDataSet(final String datasetId, final int tagId) {
        return this.getDataSets().get(datasetId).getEntries().containsKey(tagId);
    }

    public boolean hasTagInDataSet(final String datasetId, final String hexaTag) {
        if (hasDataSet(datasetId)) {
            return this.hasTagInDataSet(datasetId, getTagFromHex(hexaTag));
        }
        return false;
    }

    public static int getTagFromHex(String hexa) throws IllegalArgumentException {
        return ByteBuffer.wrap(ISOUtil.hex2byte(hexa)).get();
    }
}
