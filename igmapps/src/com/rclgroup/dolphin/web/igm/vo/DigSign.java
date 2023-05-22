package com.rclgroup.dolphin.web.igm.vo;

public class DigSign {
	public String startSignature;
	public String startCertificate;
	public String signerVersion ;

   
	public String getStartSignature() {
		return startSignature;
	}

	public void setStartSignature(String startSignature) {
		this.startSignature = startSignature;
	}

	public String getStartCertificate() {
		return startCertificate;
	}

	public void setStartCertificate(String startCertificate) {
		this.startCertificate = startCertificate;
	}

	public String getSignerVersion() {
		return signerVersion;
	}

	public void setSignerVersion(String signerVersion) {
		this.signerVersion = signerVersion;
	}
}
