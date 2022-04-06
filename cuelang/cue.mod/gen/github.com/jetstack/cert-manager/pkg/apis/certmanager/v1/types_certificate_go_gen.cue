// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/jetstack/cert-manager/pkg/apis/certmanager/v1

package v1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	cmmeta "github.com/jetstack/cert-manager/pkg/apis/meta/v1"
)

// A Certificate resource should be created to ensure an up to date and signed
// x509 certificate is stored in the Kubernetes Secret resource named in `spec.secretName`.
//
// The stored certificate will be renewed before it expires (as configured by `spec.renewBefore`).
// +k8s:openapi-gen=true
#Certificate: {
	metav1.#TypeMeta
	metadata?: metav1.#ObjectMeta @go(ObjectMeta)

	// Desired state of the Certificate resource.
	spec: #CertificateSpec @go(Spec)

	// Status of the Certificate. This is set and managed automatically.
	// +optional
	status: #CertificateStatus @go(Status)
}

// CertificateList is a list of Certificates
#CertificateList: {
	metav1.#TypeMeta
	metadata: metav1.#ListMeta @go(ListMeta)
	items: [...#Certificate] @go(Items,[]Certificate)
}

// +kubebuilder:validation:Enum=RSA;ECDSA;Ed25519
#PrivateKeyAlgorithm: string // #enumPrivateKeyAlgorithm

#enumPrivateKeyAlgorithm:
	#RSAKeyAlgorithm |
	#ECDSAKeyAlgorithm |
	#Ed25519KeyAlgorithm

// Denotes the RSA private key type.
#RSAKeyAlgorithm: #PrivateKeyAlgorithm & "RSA"

// Denotes the ECDSA private key type.
#ECDSAKeyAlgorithm: #PrivateKeyAlgorithm & "ECDSA"

// Denotes the Ed25519 private key type.
#Ed25519KeyAlgorithm: #PrivateKeyAlgorithm & "Ed25519"

// +kubebuilder:validation:Enum=PKCS1;PKCS8
#PrivateKeyEncoding: string // #enumPrivateKeyEncoding

#enumPrivateKeyEncoding:
	#PKCS1 |
	#PKCS8

// PKCS1 key encoding will produce PEM files that include the type of
// private key as part of the PEM header, e.g. `BEGIN RSA PRIVATE KEY`.
// If the keyAlgorithm is set to 'ECDSA', this will produce private keys
// that use the `BEGIN EC PRIVATE KEY` header.
#PKCS1: #PrivateKeyEncoding & "PKCS1"

// PKCS8 key encoding will produce PEM files with the `BEGIN PRIVATE KEY`
// header. It encodes the keyAlgorithm of the private key as part of the
// DER encoded PEM block.
#PKCS8: #PrivateKeyEncoding & "PKCS8"

// CertificateSpec defines the desired state of Certificate.
// A valid Certificate requires at least one of a CommonName, DNSName, or
// URISAN to be valid.
#CertificateSpec: {
	// Full X509 name specification (https://golang.org/pkg/crypto/x509/pkix/#Name).
	// +optional
	subject?: null | #X509Subject @go(Subject,*X509Subject)

	// CommonName is a common name to be used on the Certificate.
	// The CommonName should have a length of 64 characters or fewer to avoid
	// generating invalid CSRs.
	// This value is ignored by TLS clients when any subject alt name is set.
	// This is x509 behaviour: https://tools.ietf.org/html/rfc6125#section-6.4.4
	// +optional
	commonName?: string @go(CommonName)

	// The requested 'duration' (i.e. lifetime) of the Certificate. This option
	// may be ignored/overridden by some issuer types. If unset this defaults to
	// 90 days. Certificate will be renewed either 2/3 through its duration or
	// `renewBefore` period before its expiry, whichever is later. Minimum
	// accepted duration is 1 hour. Value must be in units accepted by Go
	// time.ParseDuration https://golang.org/pkg/time/#ParseDuration
	// +optional
	duration?: null | metav1.#Duration @go(Duration,*metav1.Duration)

	// How long before the currently issued certificate's expiry
	// cert-manager should renew the certificate. The default is 2/3 of the
	// issued certificate's duration. Minimum accepted value is 5 minutes.
	// Value must be in units accepted by Go time.ParseDuration
	// https://golang.org/pkg/time/#ParseDuration
	// +optional
	renewBefore?: null | metav1.#Duration @go(RenewBefore,*metav1.Duration)

	// DNSNames is a list of DNS subjectAltNames to be set on the Certificate.
	// +optional
	dnsNames?: [...string] @go(DNSNames,[]string)

	// IPAddresses is a list of IP address subjectAltNames to be set on the Certificate.
	// +optional
	ipAddresses?: [...string] @go(IPAddresses,[]string)

	// URIs is a list of URI subjectAltNames to be set on the Certificate.
	// +optional
	uris?: [...string] @go(URIs,[]string)

	// EmailAddresses is a list of email subjectAltNames to be set on the Certificate.
	// +optional
	emailAddresses?: [...string] @go(EmailAddresses,[]string)

	// SecretName is the name of the secret resource that will be automatically
	// created and managed by this Certificate resource.
	// It will be populated with a private key and certificate, signed by the
	// denoted issuer.
	secretName: string @go(SecretName)

	// SecretTemplate defines annotations and labels to be copied to the
	// Certificate's Secret. Labels and annotations on the Secret will be changed
	// as they appear on the SecretTemplate when added or removed. SecretTemplate
	// annotations are added in conjunction with, and cannot overwrite, the base
	// set of annotations cert-manager sets on the Certificate's Secret.
	// +optional
	secretTemplate?: null | #CertificateSecretTemplate @go(SecretTemplate,*CertificateSecretTemplate)

	// Keystores configures additional keystore output formats stored in the
	// `secretName` Secret resource.
	// +optional
	keystores?: null | #CertificateKeystores @go(Keystores,*CertificateKeystores)

	// IssuerRef is a reference to the issuer for this certificate.
	// If the `kind` field is not set, or set to `Issuer`, an Issuer resource
	// with the given name in the same namespace as the Certificate will be used.
	// If the `kind` field is set to `ClusterIssuer`, a ClusterIssuer with the
	// provided name will be used.
	// The `name` field in this stanza is required at all times.
	issuerRef: cmmeta.#ObjectReference @go(IssuerRef)

	// IsCA will mark this Certificate as valid for certificate signing.
	// This will automatically add the `cert sign` usage to the list of `usages`.
	// +optional
	isCA?: bool @go(IsCA)

	// Usages is the set of x509 usages that are requested for the certificate.
	// Defaults to `digital signature` and `key encipherment` if not specified.
	// +optional
	usages?: [...#KeyUsage] @go(Usages,[]KeyUsage)

	// Options to control private keys used for the Certificate.
	// +optional
	privateKey?: null | #CertificatePrivateKey @go(PrivateKey,*CertificatePrivateKey)

	// EncodeUsagesInRequest controls whether key usages should be present
	// in the CertificateRequest
	// +optional
	encodeUsagesInRequest?: null | bool @go(EncodeUsagesInRequest,*bool)

	// revisionHistoryLimit is the maximum number of CertificateRequest revisions
	// that are maintained in the Certificate's history. Each revision represents
	// a single `CertificateRequest` created by this Certificate, either when it
	// was created, renewed, or Spec was changed. Revisions will be removed by
	// oldest first if the number of revisions exceeds this number. If set,
	// revisionHistoryLimit must be a value of `1` or greater. If unset (`nil`),
	// revisions will not be garbage collected. Default value is `nil`.
	// +kubebuilder:validation:ExclusiveMaximum=false
	// +optional
	revisionHistoryLimit?: null | int32 @go(RevisionHistoryLimit,*int32)

	// AdditionalOutputFormats defines extra output formats of the private key
	// and signed certificate chain to be written to this Certificate's target
	// Secret. This is an Alpha Feature and is only enabled with the
	// `--feature-gates=AdditionalCertificateOutputFormats=true` option on both
	// the controller and webhook components.
	// +optional
	additionalOutputFormats?: [...#CertificateAdditionalOutputFormat] @go(AdditionalOutputFormats,[]CertificateAdditionalOutputFormat)
}

// CertificatePrivateKey contains configuration options for private keys
// used by the Certificate controller.
// This allows control of how private keys are rotated.
#CertificatePrivateKey: {
	// RotationPolicy controls how private keys should be regenerated when a
	// re-issuance is being processed.
	// If set to Never, a private key will only be generated if one does not
	// already exist in the target `spec.secretName`. If one does exists but it
	// does not have the correct algorithm or size, a warning will be raised
	// to await user intervention.
	// If set to Always, a private key matching the specified requirements
	// will be generated whenever a re-issuance occurs.
	// Default is 'Never' for backward compatibility.
	// +optional
	rotationPolicy?: #PrivateKeyRotationPolicy @go(RotationPolicy)

	// The private key cryptography standards (PKCS) encoding for this
	// certificate's private key to be encoded in.
	// If provided, allowed values are `PKCS1` and `PKCS8` standing for PKCS#1
	// and PKCS#8, respectively.
	// Defaults to `PKCS1` if not specified.
	// +optional
	encoding?: #PrivateKeyEncoding @go(Encoding)

	// Algorithm is the private key algorithm of the corresponding private key
	// for this certificate. If provided, allowed values are either `RSA`,`Ed25519` or `ECDSA`
	// If `algorithm` is specified and `size` is not provided,
	// key size of 256 will be used for `ECDSA` key algorithm and
	// key size of 2048 will be used for `RSA` key algorithm.
	// key size is ignored when using the `Ed25519` key algorithm.
	// +optional
	algorithm?: #PrivateKeyAlgorithm @go(Algorithm)

	// Size is the key bit size of the corresponding private key for this certificate.
	// If `algorithm` is set to `RSA`, valid values are `2048`, `4096` or `8192`,
	// and will default to `2048` if not specified.
	// If `algorithm` is set to `ECDSA`, valid values are `256`, `384` or `521`,
	// and will default to `256` if not specified.
	// If `algorithm` is set to `Ed25519`, Size is ignored.
	// No other values are allowed.
	// +optional
	size?: int @go(Size)
}

// Denotes how private keys should be generated or sourced when a Certificate
// is being issued.
#PrivateKeyRotationPolicy: string

// CertificateOutputFormatType specifies which additional output formats should
// be written to the Certificate's target Secret.
// Allowed values are `DER` or `CombinedPEM`.
// When Type is set to `DER` an additional entry `key.der` will be written to
// the Secret, containing the binary format of the private key.
// When Type is set to `CombinedPEM` an additional entry `tls-combined.pem`
// will be written to the Secret, containing the PEM formatted private key and
// signed certificate chain (tls.key + tls.crt concatenated).
// +kubebuilder:validation:Enum=DER;CombinedPEM
#CertificateOutputFormatType: string // #enumCertificateOutputFormatType

#enumCertificateOutputFormatType:
	#CertificateOutputFormatDER |
	#CertificateOutputFormatCombinedPEM

// CertificateOutputFormatDERKey is the name of the data entry in the Secret
// resource used to store the DER formatted private key.
#CertificateOutputFormatDERKey: "key.der"

// CertificateOutputFormatDER  writes the Certificate's private key in DER
// binary format to the `key.der` target Secret Data key.
#CertificateOutputFormatDER: #CertificateOutputFormatType & "DER"

// CertificateOutputFormatCombinedPEMKey is the name of the data entry in the Secret
// resource used to store the combined PEM (key + signed certificate).
#CertificateOutputFormatCombinedPEMKey: "tls-combined.pem"

// CertificateOutputFormatCombinedPEM  writes the Certificate's signed
// certificate chain and private key, in PEM format, to the
// `tls-combined.pem` target Secret Data key. The value at this key will
// include the private key PEM document, followed by at least one new line
// character, followed by the chain of signed certificate PEM documents
// (`<private key> + \n + <signed certificate chain>`).
#CertificateOutputFormatCombinedPEM: #CertificateOutputFormatType & "CombinedPEM"

// CertificateAdditionalOutputFormat defines an additional output format of a
// Certificate resource. These contain supplementary data formats of the signed
// certificate chain and paired private key.
#CertificateAdditionalOutputFormat: {
	// Type is the name of the format type that should be written to the
	// Certificate's target Secret.
	type: #CertificateOutputFormatType @go(Type)
}

// X509Subject Full X509 name specification
#X509Subject: {
	// Organizations to be used on the Certificate.
	// +optional
	organizations?: [...string] @go(Organizations,[]string)

	// Countries to be used on the Certificate.
	// +optional
	countries?: [...string] @go(Countries,[]string)

	// Organizational Units to be used on the Certificate.
	// +optional
	organizationalUnits?: [...string] @go(OrganizationalUnits,[]string)

	// Cities to be used on the Certificate.
	// +optional
	localities?: [...string] @go(Localities,[]string)

	// State/Provinces to be used on the Certificate.
	// +optional
	provinces?: [...string] @go(Provinces,[]string)

	// Street addresses to be used on the Certificate.
	// +optional
	streetAddresses?: [...string] @go(StreetAddresses,[]string)

	// Postal codes to be used on the Certificate.
	// +optional
	postalCodes?: [...string] @go(PostalCodes,[]string)

	// Serial number to be used on the Certificate.
	// +optional
	serialNumber?: string @go(SerialNumber)
}

// CertificateKeystores configures additional keystore output formats to be
// created in the Certificate's output Secret.
#CertificateKeystores: {
	// JKS configures options for storing a JKS keystore in the
	// `spec.secretName` Secret resource.
	// +optional
	jks?: null | #JKSKeystore @go(JKS,*JKSKeystore)

	// PKCS12 configures options for storing a PKCS12 keystore in the
	// `spec.secretName` Secret resource.
	// +optional
	pkcs12?: null | #PKCS12Keystore @go(PKCS12,*PKCS12Keystore)
}

// JKS configures options for storing a JKS keystore in the `spec.secretName`
// Secret resource.
#JKSKeystore: {
	// Create enables JKS keystore creation for the Certificate.
	// If true, a file named `keystore.jks` will be created in the target
	// Secret resource, encrypted using the password stored in
	// `passwordSecretRef`.
	// The keystore file will only be updated upon re-issuance.
	// A file named `truststore.jks` will also be created in the target
	// Secret resource, encrypted using the password stored in
	// `passwordSecretRef` containing the issuing Certificate Authority
	create: bool @go(Create)

	// PasswordSecretRef is a reference to a key in a Secret resource
	// containing the password used to encrypt the JKS keystore.
	passwordSecretRef: cmmeta.#SecretKeySelector @go(PasswordSecretRef)
}

// PKCS12 configures options for storing a PKCS12 keystore in the
// `spec.secretName` Secret resource.
#PKCS12Keystore: {
	// Create enables PKCS12 keystore creation for the Certificate.
	// If true, a file named `keystore.p12` will be created in the target
	// Secret resource, encrypted using the password stored in
	// `passwordSecretRef`.
	// The keystore file will only be updated upon re-issuance.
	// A file named `truststore.p12` will also be created in the target
	// Secret resource, encrypted using the password stored in
	// `passwordSecretRef` containing the issuing Certificate Authority
	create: bool @go(Create)

	// PasswordSecretRef is a reference to a key in a Secret resource
	// containing the password used to encrypt the PKCS12 keystore.
	passwordSecretRef: cmmeta.#SecretKeySelector @go(PasswordSecretRef)
}

// CertificateStatus defines the observed state of Certificate
#CertificateStatus: {
	// List of status conditions to indicate the status of certificates.
	// Known condition types are `Ready` and `Issuing`.
	// +optional
	conditions?: [...#CertificateCondition] @go(Conditions,[]CertificateCondition)

	// LastFailureTime is the time as recorded by the Certificate controller
	// of the most recent failure to complete a CertificateRequest for this
	// Certificate resource.
	// If set, cert-manager will not re-request another Certificate until
	// 1 hour has elapsed from this time.
	// +optional
	lastFailureTime?: null | metav1.#Time @go(LastFailureTime,*metav1.Time)

	// The time after which the certificate stored in the secret named
	// by this resource in spec.secretName is valid.
	// +optional
	notBefore?: null | metav1.#Time @go(NotBefore,*metav1.Time)

	// The expiration time of the certificate stored in the secret named
	// by this resource in `spec.secretName`.
	// +optional
	notAfter?: null | metav1.#Time @go(NotAfter,*metav1.Time)

	// RenewalTime is the time at which the certificate will be next
	// renewed.
	// If not set, no upcoming renewal is scheduled.
	// +optional
	renewalTime?: null | metav1.#Time @go(RenewalTime,*metav1.Time)

	// The current 'revision' of the certificate as issued.
	//
	// When a CertificateRequest resource is created, it will have the
	// `cert-manager.io/certificate-revision` set to one greater than the
	// current value of this field.
	//
	// Upon issuance, this field will be set to the value of the annotation
	// on the CertificateRequest resource used to issue the certificate.
	//
	// Persisting the value on the CertificateRequest resource allows the
	// certificates controller to know whether a request is part of an old
	// issuance or if it is part of the ongoing revision's issuance by
	// checking if the revision value in the annotation is greater than this
	// field.
	// +optional
	revision?: null | int @go(Revision,*int)

	// The name of the Secret resource containing the private key to be used
	// for the next certificate iteration.
	// The keymanager controller will automatically set this field if the
	// `Issuing` condition is set to `True`.
	// It will automatically unset this field when the Issuing condition is
	// not set or False.
	// +optional
	nextPrivateKeySecretName?: null | string @go(NextPrivateKeySecretName,*string)
}

// CertificateCondition contains condition information for an Certificate.
#CertificateCondition: {
	// Type of the condition, known values are (`Ready`, `Issuing`).
	type: #CertificateConditionType @go(Type)

	// Status of the condition, one of (`True`, `False`, `Unknown`).
	status: cmmeta.#ConditionStatus @go(Status)

	// LastTransitionTime is the timestamp corresponding to the last status
	// change of this condition.
	// +optional
	lastTransitionTime?: null | metav1.#Time @go(LastTransitionTime,*metav1.Time)

	// Reason is a brief machine readable explanation for the condition's last
	// transition.
	// +optional
	reason?: string @go(Reason)

	// Message is a human readable description of the details of the last
	// transition, complementing reason.
	// +optional
	message?: string @go(Message)

	// If set, this represents the .metadata.generation that the condition was
	// set based upon.
	// For instance, if .metadata.generation is currently 12, but the
	// .status.condition[x].observedGeneration is 9, the condition is out of date
	// with respect to the current state of the Certificate.
	// +optional
	observedGeneration?: int64 @go(ObservedGeneration)
}

// CertificateConditionType represents an Certificate condition value.
#CertificateConditionType: string // #enumCertificateConditionType

#enumCertificateConditionType:
	#CertificateConditionReady |
	#CertificateConditionIssuing

// CertificateConditionReady indicates that a certificate is ready for use.
// This is defined as:
// - The target secret exists
// - The target secret contains a certificate that has not expired
// - The target secret contains a private key valid for the certificate
// - The commonName and dnsNames attributes match those specified on the Certificate
#CertificateConditionReady: #CertificateConditionType & "Ready"

// A condition added to Certificate resources when an issuance is required.
// This condition will be automatically added and set to true if:
//   * No keypair data exists in the target Secret
//   * The data stored in the Secret cannot be decoded
//   * The private key and certificate do not have matching public keys
//   * If a CertificateRequest for the current revision exists and the
//     certificate data stored in the Secret does not match the
//    `status.certificate` on the CertificateRequest.
//   * If no CertificateRequest resource exists for the current revision,
//     the options on the Certificate resource are compared against the
//     x509 data in the Secret, similar to what's done in earlier versions.
//     If there is a mismatch, an issuance is triggered.
// This condition may also be added by external API consumers to trigger
// a re-issuance manually for any other reason.
//
// It will be removed by the 'issuing' controller upon completing issuance.
#CertificateConditionIssuing: #CertificateConditionType & "Issuing"

// CertificateSecretTemplate defines the default labels and annotations
// to be copied to the Kubernetes Secret resource named in `CertificateSpec.secretName`.
#CertificateSecretTemplate: {
	// Annotations is a key value map to be copied to the target Kubernetes Secret.
	// +optional
	annotations?: {[string]: string} @go(Annotations,map[string]string)

	// Labels is a key value map to be copied to the target Kubernetes Secret.
	// +optional
	labels?: {[string]: string} @go(Labels,map[string]string)
}
