# aws.comprehend 0.2.1 (in development)

* Refactor batch response processing to improve reliability (#21)

# aws.comprehend 0.2.0

### New features

* Medical support for entities (`detect_medical_entities`) and protected health information (`detect_medical_phi`) (@dkincaid, #20)
* `detect_syntax` function to perform syntax analysis (#14)

### Fixes and minor improvements

* Better error message when AWS credentials are not provided (#15)
* Fix missing import of `locate_credential` from `aws.signature` (#5)
* Fix bug in batch `detect_entities` when documents have different numbers of entities (@MarcinKosinski, #18)
* @antoine-sachet taking over as maintainer

# aws.comprehend 0.1.2

* First CRAN release

# aws.comprehend 0.1.1

* Initial release.
