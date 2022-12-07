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

import org.jpos.iso.ISOUtil;

import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

/**
 * A class that contain the values of a specific usage in a VISA TLV
 *
 * @author apr@cs.com.uy
 * @author avolpe@fintech.works
 */
public class DataSet {

    private int id;
    private final Map<Integer, TLVEntry> entries;

    public DataSet() {
        super();
        this.entries = new HashMap<>();
    }

    public DataSet(final int id) {
        this();
        this.id = id;
    }

    public DataSet(final String id) {
        this(DataSetField.getTagFromHex(id));
    }

    public int getId() {
        return this.id;
    }

    public String getIdAsHex() {
        return Integer.toHexString(this.id);

    }

    public Map<Integer, TLVEntry> getEntries() {
        return this.entries;
    }

    public void add(final int tag, final byte[] value) {
        this.entries.put(tag, new TLVEntry(tag, value));
    }

    public void add(final String hexTag, final byte[] value) {
        this.add(DataSetField.getTagFromHex(hexTag), value);
    }

    public void addAscii(final String hexTag, final String value) {
        this.add(hexTag, ISOUtil.asciiToEbcdic(value));
    }

    public List<byte[]> get(final int tag) {
        final List<byte[]> l = new ArrayList<>();
        for (final Entry<Integer, TLVEntry> entry : this.entries.entrySet()) {
            if (entry.getValue().getTag() == tag) {
                l.add(entry.getValue().getValue());
            }
        }
        return l;
    }

    public byte[] getFirst(final int tag) {
        for (final Entry<Integer, TLVEntry> entry : this.entries.entrySet()) {
            if (entry.getValue().getTag() == tag) {
                return entry.getValue().getValue();
            }
        }
        return new byte[0];
    }

    public byte[] pack() {
        final int l = this.length();
        final ByteBuffer buf = ByteBuffer.allocate(l);
        buf.put((byte) this.id);
        buf.putShort((short) (l - 3));
        for (final Entry<Integer, TLVEntry> entry : this.entries.entrySet()) {
            buf.put(entry.getValue().pack());
        }
        return buf.array();
    }

    public int unpack(final byte[] b, final int offset) {
        final ByteBuffer buf = ByteBuffer.wrap(b, offset, b.length - offset);
        this.id = buf.get();
        final int l = buf.getShort();
        final byte[] bb = new byte[l];
        buf.get(bb);
        int consumed = 0;
        while (consumed < l) {
            final TLVEntry entry = new TLVEntry();
            consumed += entry.unpack(bb, consumed);
            this.entries.put(entry.getTag(), entry);
        }
        return consumed + 3;
    }

    /**
     * @return total length required to pack this dataset (includes 3-bytes
     * required to pack Tag and LL)
     */
    public int length() {
        int l = 3;
        for (final Entry<Integer, TLVEntry> entry : this.entries.entrySet()) {
            l += entry.getValue().length();
        }
        return l;
    }

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder(String.format("%02X{", this.id));
        int i = 0;
        for (final Entry<Integer, TLVEntry> entry : this.entries.entrySet()) {
            if (i > 0) {
                sb.append(", ");
            }
            sb.append(ISOUtil.byte2hex(ISOUtil.int2byte(entry.getValue().getTag())))
                    .append(":")
                    .append(entry.getValue().getAsciiValue())
            ;
            i++;
        }
        sb.append('}');
        return sb.toString();
    }

    public static class TLVEntry {
        int tag;
        byte[] value;

        public TLVEntry() {
            super();
        }

        public TLVEntry(final int tag, final byte[] value) {
            this.tag = tag;
            this.value = value;
            if (value == null) {
                throw new NullPointerException("value cannot be null");
            } else if (value.length > 255) {
                throw new IllegalArgumentException("value has invalid length " + value.length);
            }
        }

        public int getTag() {
            return this.tag;
        }

        public byte[] getValue() {
            return this.value;
        }

        /**
         * @return the Ascii value (the TLVEntry value is added as the EBCDIC value), never null
         */
        public String getAsciiValue() {
            return ISOUtil.ebcdicToAscii(this.value);
        }

        public byte[] pack() {
            final byte[] b = new byte[this.value.length + 2];
            final ByteBuffer buf = ByteBuffer.wrap(b);
            buf.put((byte) this.tag);
            buf.put((byte) this.value.length);
            buf.put(this.value);
            return b;
        }

        public int unpack(final byte[] b, final int offset) {
            final ByteBuffer buf = ByteBuffer.wrap(b, offset, b.length - offset);
            this.tag = buf.get();
            final int l = buf.get();
            final byte[] bb = new byte[l];
            buf.get(bb);
            this.value = bb;
            return l + 2;
        }

        /**
         * @return total length required to pack this TLV field (includes
         * 2-bytes required to pack tag and length)
         */
        public int length() {
            return this.value.length + 2;
        }

        @Override
        public String toString() {
            return String.format("%02X:%s", this.tag, new String(this.value));
        }
    }

    /**
     * Returns ASCII Value for the specified tag in a DataSet
     */
    public String getAsciiValueForTLV(final int tagId) {
        return this.entries.get(tagId).getAsciiValue();
    }
}
