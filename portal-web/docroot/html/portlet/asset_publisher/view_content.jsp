<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/html/portlet/asset_publisher/init.jsp" %>

<%
String returnToFullPageURL = ParamUtil.getString(request, "returnToFullPageURL");

if (Validator.isNotNull(returnToFullPageURL)) {
	portletDisplay.setURLBack(returnToFullPageURL);
}

long assetEntryId = ParamUtil.getLong(request, "assetEntryId");
String type = ParamUtil.getString(request, "type");
long groupId = ParamUtil.getLong(request, "groupId", scopeGroupId);
String urlTitle = ParamUtil.getString(request, "urlTitle");

boolean print = ParamUtil.getString(request, "viewMode").equals(Constants.PRINT);

AssetEntry assetEntry = null;

AssetRendererFactory assetRendererFactory = AssetRendererFactoryRegistryUtil.getAssetRendererFactoryByType(type);
AssetRenderer assetRenderer = null;

if (Validator.isNotNull(urlTitle)) {
	assetRenderer = assetRendererFactory.getAssetRenderer(groupId, urlTitle);

	assetEntry = assetRendererFactory.getAssetEntry(assetRendererFactory.getClassName(), assetRenderer.getClassPK());
}
else {
	assetEntry = assetRendererFactory.getAssetEntry(assetEntryId);

	assetRenderer = assetRendererFactory.getAssetRenderer(assetEntry.getClassPK());
}
%>

<c:choose>
	<c:when test="<%= assetEntry.isVisible() %>">

		<%
		String title = assetRenderer.getTitle(locale);

		request.setAttribute("view.jsp-results", new ArrayList());
		request.setAttribute("view.jsp-assetEntryIndex", new Integer(0));
		request.setAttribute("view.jsp-assetEntry", assetEntry);
		request.setAttribute("view.jsp-assetRendererFactory", assetRendererFactory);
		request.setAttribute("view.jsp-assetRenderer", assetRenderer);
		request.setAttribute("view.jsp-title", title);
		request.setAttribute("view.jsp-print", new Boolean(print));

		PortalUtil.addPortletBreadcrumbEntry(request, title, currentURL);
		%>

		<div>
			<liferay-util:include page="/html/portlet/asset_publisher/display/full_content.jsp" />
		</div>

		<liferay-util:include page="/html/portlet/asset_publisher/asset_html_metadata.jsp" />
	</c:when>
	<c:otherwise>

		<%
		SessionErrors.add(renderRequest, NoSuchModelException.class.getName());
		%>

		<liferay-util:include page="/html/portlet/asset_publisher/error.jsp" />
	</c:otherwise>
</c:choose>