<%@ Page Title="" Language="C#" MasterPageFile="~/Content/Site.Master" Inherits="System.Web.Mvc.ViewPage<FunnelWeb.Web.Features.Wiki.Views.PageModel>" %>

<asp:content contentplaceholderid="TitleContent" runat="server"><%= Model.Entry.MetaTitle %></asp:content>
<asp:content contentplaceholderid="MetaContent" runat="server">
  <meta name="description" content="<%= Model.Entry.MetaDescription %>" />
  <meta name="keywords" content="<%= Model.Entry.MetaKeywords %>" /><% if (Model.IsPriorVersion) { %><%--We ask Mr. Google very nicely to please not index this page.--%>
  <meta name="robots" content="noindex, nofollow" /><% } %>
  <link rel="canonical" href="<%= Html.Qualify(Html.ActionUrl("Page", new { page = Model.Entry.Name })) %>" />
  <link rel="pingback" href="<%= Html.Qualify("/pingback") %>" />
</asp:content>
<asp:content contentplaceholderid="SummaryContent" runat="server"><%= Html.DisplayFor(model => model.Entry.Summary) %></asp:content>
<asp:content contentplaceholderid="MainContent" runat="server">      
      <h1><%= Html.ActionLink(Model.Entry.Title, "Page", new { page = Model.Entry.Name })%></h1>
      <div class="entry-date">
        <span class='month'><%= Model.Entry.FeedDate.ToString("MMM d") %></span>
        <span class='year'><%= Model.Entry.FeedDate.ToString("yyyy")%></span>
      </div>
      <div class="entry-container">
        <% if (Model.IsPriorVersion) { %>
        <div class='entry-tools'>
          <div>
            <span>You are looking at revision <%= Model.Entry.LatestRevision.RevisionNumber %> of this page, which may be out of date. <%= Html.ActionLink("View the latest version.", "Page", new { page = Model.Entry.Name })%></span>
          </div>
        </div>
        <% } %>
        <div class='entry'>
        <%= Html.DisplayFor(model => model.Entry.LatestRevision.Body) %>
        </div>  
        <div class='entry-tools'>
          <span>Last revised: <a href="<%= Html.ActionUrl("Page", new { page = Model.Page, revision = Model.Entry.LatestRevision.RevisionNumber }) %>"><%= Html.Date(Model.Entry.LatestRevision.Revised) %></a></span>
          <span><%= Html.ActionLink("History", "Revisions", new { page = Model.Page })%></span>
          <% if (ViewData.IsLoggedIn()) { %>
          <span><%= Html.ActionLink("Edit", "Edit", new { page = Model.Page })%></span>
          <% } %>
          <% if (Model.IsPriorVersion) { %>
          <div>
            <span>You are looking at revision <%= Model.Entry.LatestRevision.RevisionNumber %> of this page, which may be out of date. <%= Html.ActionLink("View the latest version.", "Page", new { page = Model.Entry.Name })%></span>
          </div>
          <% } %>
        </div>
        <% if (Model.Entry.Pingbacks.Count > 0) { %>
        <div class="trackbacks">
          <h2>Trackbacks</h2>
          <ul><% foreach (var pingback in Model.Entry.Pingbacks.Where(x => !x.IsSpam)) { %>
            <li><%= Html.Encode(pingback.TargetTitle) %> | <a href="<%= Html.AttributeEncode(pingback.TargetUri) %>"><%= Html.Encode(pingback.TargetUri) %></a></li>
            <% } %>
          </ul>
        </div>
        <% } %>
      </div>
      <div class="clear"></div>
      <% if (Model.Entry.IsDiscussionEnabled) { %>
      <div class="comments">
        <div class="comments-in">
        <a name="comments" style="display:none;">&nbsp;</a>
          <h2>Discussion</h2>
          <% if (Model.Entry.Comments.Count == 0) { %>
          <div class="empty">
            <p>No comments yet. Be the first!</p>
          </div>
          <%} %>
          <% foreach (var comment in Model.Entry.Comments.Where(x => !x.IsSpam)) { %>
          <div class="comment">
            <div class="comment-author">
              <img class="gravatar" src="<%= Html.Gravatar(comment.AuthorEmail) %>" alt="<%= Html.Encode(comment.AuthorName) %>" />
              <br />
              <%= Html.UrlLink(comment.AuthorUrl, comment.AuthorName) %>
            </div>
            <div class="comment-body"> 
              <div class="comment-date"><%= Html.Date(comment.Posted) %></div>
              <%= Html.DisplayFor(_ => comment.Body, new { Sanitize = true }) %>
            </div>
            <div class="clear">
            </div>
          </div>
          <% } %>
        </div>
      </div>

      <h2>Your Comments</h2>
      
      <%: Html.ValidationSummary("Comment unsuccessful. Please correct the errors below.") %>

      <div class='entry-comment'>
      <% using (Html.BeginForm("Page", "Wiki", new { page = Model.Page }, FormMethod.Post, new { @class = "promptBeforeUnload" })) { %>
        <div class="form-body">
          
          <div class="editor-label">
            <%: Html.LabelFor(m => m.CommenterName)%>
          </div>
          <div class="editor-field">
            <%: Html.TextBoxFor(m => m.CommenterName, Html.AttributesFor(m => m.CommenterName))%>
            <%: Html.ValidationMessageFor(m => m.CommenterName)%>
            <%: Html.HintFor(m => m.CommenterName)%>
          </div>
          
          <div class="editor-label">
            <%: Html.LabelFor(m => m.CommenterBlog)%>
          </div>
          <div class="editor-field">
            <%: Html.TextBoxFor(m => m.CommenterBlog, Html.AttributesFor(m => m.CommenterBlog))%>
            <%: Html.ValidationMessageFor(m => m.CommenterBlog)%>
            <%: Html.HintFor(m => m.CommenterBlog)%>
          </div>
          
          <div class="editor-label">
            <%: Html.LabelFor(m => m.CommenterEmail)%>
          </div>
          <div class="editor-field">
            <%: Html.TextBoxFor(m => m.CommenterEmail, Html.AttributesFor(m => m.CommenterEmail))%>
            <%: Html.ValidationMessageFor(m => m.CommenterEmail)%>
            <%: Html.HintFor(m => m.CommenterEmail)%>
          </div>
          
          <div class="editor-label">
            <%: Html.LabelFor(m => m.Comments)%>
          </div>
          <div class="editor-field">
            <%: Html.EditorFor(m => m.Comments, Html.AttributesFor(m => m.Comments))%>
            <%: Html.ValidationMessageFor(m => m.Comments)%>
            <%: Html.HintFor(m => m.Comments)%>
          </div>
          
          <div class="editor-field">
            <input type="submit" id="submit" class="submit" value="Submit" />
          </div>
        </div>
        <% } %>
      </div>
      <h3>Preview</h3>
      <div id="wmd-preview" class="wmd-panel"></div>
      <% } %>
</asp:content>
