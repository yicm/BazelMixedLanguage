
package com.xiaobaiai.test;

public class CommonStatus {
    public enum Status {
        TEST_SUCCESS(0),
        TEST_FAILED(-1);

        private int status_;
        Status(int status) {
            status_ status;
        }

        public int getStatus() {
            return status_;
        }
    }

    private int common_status_;
    CommonStatus(int status) {
        common_status_ = status;
    }

    public boolean equal(Status status) {
        return common_status_ == status.getStatus();
    }

    public Status getStatus() {
        for (Status s : Status.values()) {
            if (s.status_ == common_status_) {
                return s;
            }
        }
    }

    public void setStatus(int status) {
        common_status_ = status;
    }
}