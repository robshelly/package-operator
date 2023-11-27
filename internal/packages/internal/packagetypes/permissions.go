package packagetypes

import (
	"bytes"
	"context"
	"fmt"
	"regexp"
	"strings"

	"k8s.io/apimachinery/pkg/runtime/schema"
)

var (
	apiVersionRegEx = regexp.MustCompile(`(?m)^apiVersion:(.*)$`)
	kindRegEx       = regexp.MustCompile(`(?m)^kind:(.*)$`)
	isExternalRegEx = regexp.MustCompile(`(?m)package-operator\.run/external:.*"True"$`)
)

func Permissions(
	ctx context.Context,
	files Files,
) (PackagePermissions, error) {
	perms := PackagePermissions{}

	managedGK := map[schema.GroupKind]struct{}{}
	externalGK := map[schema.GroupKind]struct{}{}

	// GKs from un-templated files.
	for _, file := range files {
		for _, yamlDocument := range bytes.Split(bytes.Trim(file, "---\n"), []byte("---\n")) {
			gk, isExternal, err := permissionsFromTemplateFile(ctx, yamlDocument)
			if err != nil {
				return perms, err
			}
			if isExternal {
				externalGK[gk] = struct{}{}
			} else {
				managedGK[gk] = struct{}{}
			}
		}
	}

	perms.Managed = mapKeysToList(managedGK)
	perms.External = mapKeysToList(externalGK)
	return perms, nil
}

func permissionsFromTemplateFile(
	_ context.Context, file []byte,
) (gk schema.GroupKind, isExternal bool, err error) {
	apiVersion := strings.TrimSpace(strings.TrimPrefix(apiVersionRegEx.FindString(string(file)), "apiVersion:"))
	gv, err := schema.ParseGroupVersion(apiVersion)
	if err != nil {
		return gk, false, fmt.Errorf("parsing apiVersion: %w", err)
	}

	gk.Group = gv.Group
	gk.Kind = strings.TrimSpace(strings.TrimPrefix(kindRegEx.FindString(string(file)), "kind:"))
	isExternal = isExternalRegEx.Match(file)
	return
}

func mapKeysToList[K comparable, V any](in map[K]V) []K {
	out := make([]K, len(in))
	var i int
	for k := range in {
		out[i] = k
		i++
	}
	return out
}
