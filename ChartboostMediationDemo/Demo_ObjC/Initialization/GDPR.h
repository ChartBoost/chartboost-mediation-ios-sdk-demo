// Copyright 2023-2024 Chartboost, Inc.
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.

#ifndef GDPR_h
#define GDPR_h

/// A convenient structure that defines a user's GDPR privacy settings.
/// For more information about GDPR, see: https://answers.chartboost.com/en-us/articles/115001489613
typedef struct {
    BOOL isSubject;
    BOOL hasGivenConsent;
} GDPR;

/// The default GDPR value.
static GDPR defaultGDPR = { .isSubject = NO, .hasGivenConsent = YES };

#endif /* GDPR_h */
