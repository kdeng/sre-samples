package nz.net.osnz.helper;

import com.google.appengine.api.utils.SystemProperty;
import com.google.cloud.WriteChannel;
import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.BlobInfo;
import com.google.cloud.storage.Storage;
import com.google.cloud.storage.StorageException;
import com.google.cloud.storage.StorageOptions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;

import static java.nio.charset.StandardCharsets.UTF_8;

/**
 * @author Kefeng Deng (deng@51any.com)
 */
public class StorageHelper {

    private static final Logger LOG = LoggerFactory.getLogger(StorageHelper.class);

    private StorageHelper() {
        // Cannot be instantiated
    }

    public static String getDefaultBucketName() {
        return String.format("%s.appspot.com", SystemProperty.applicationId.get());
    }

    public static String getAdobeDataFeedBlobNameByDate(String reportDate) {
        return String.format("adobe-data-feed-csv-result/%s-bigquery-job-status.json", reportDate);
    }

    private static Storage getStorage() {
        return StorageOptions.getDefaultInstance().getService();
    }

    /**
     * Write a {@code String} content into a GCS blob {@code Blob}
     *
     * @param bucketName is GCS bucket name
     * @param blobName   is GCS object name
     * @param content    is the content be saved into blob
     * @throws IOException if the blob cannot be saved into GCS
     */
    public static void writer(String bucketName, String blobName, String content) throws IOException {
        BlobId blobId = BlobId.of(bucketName, blobName);
        byte[] bytes = content.getBytes(UTF_8);

        BlobInfo blobInfo = BlobInfo.newBuilder(blobId).setContentType("text/plain").build();
        try (WriteChannel writer = getStorage().writer(blobInfo)) {
            try {
                writer.write(ByteBuffer.wrap(bytes, 0, bytes.length));
            } catch (Exception ex) {
                LOG.error("Unexpected error during writing content to GCS bucket", ex);
            }
        }
    }

    /**
     * Check whether bucket object already exists or not
     *
     * @param bucketName is bucket name
     * @param blobName   is blob object name
     * @return
     */
    public static boolean isBucketObjectExists(String bucketName, String blobName) {
        try {
            BlobId blobId = BlobId.of(bucketName, blobName);
            return getStorage().get(blobId) != null;
        } catch (Exception ex) {
            // ignore all exceptions
        }
        return false;
    }

    /**
     * Fetch the blob content from GCS
     *
     * @param bucketName is bucket name
     * @param blobName   is blob name path
     * @return a content in {@code String}
     * @throws StorageException if the object cannot be reached
     */
    public static String read(String bucketName, String blobName) throws StorageException {
        BlobId blobId = BlobId.of(bucketName, blobName);
        return new String(getStorage().readAllBytes(blobId), StandardCharsets.UTF_8);
    }

}
